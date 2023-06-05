<#
    AvScanner - Integrated file with all of the below modules
    #########################################################
    1. Component detail fetcher - To gather file share detail based on componet
    2. SNA file fetcher - To gather SNA file detail from respective file share
    3. Implemented with PAM vault connection for password retreival
    4. Enabled scan for diff backup files also
    5. Updated net use command mapping using separate function Invoke-Process
    6. Updated log data collection mechanism
    7. Updated PAM vault with additional security measure(certificate thumbprint) for password retreival.
#>

#################Log Files###############

$logFile = "C:\Windows\Temp\NewSNAFileScanQueue_Logs.txt"         #Old log file
#$logFile = "C:\Users\VST7COB\Desktop\PScripts\VirusScan\NewSNAFileScanQueue_Logs.txt"

########################################

function Update-Log  ($logtype, $message) {
    "[$([datetime]::Now)][$logtype] : $message" >> $logFile        
}

function Invoke-Process ($command, $arguments) {
    $process = New-Object System.Diagnostics.Process -Property @{StartInfo = New-Object System.Diagnostics.ProcessStartInfo -Property @{
            FileName               = $command
            Arguments              = $arguments
            CreateNoWindow         = $true
            UseShellExecute        = $false
            RedirectStandardError  = $true
            RedirectStandardOutput = $true
        }
    }

    $process.Start() | Out-Null
    $errmsg = $process.StandardError.ReadToEnd().Trim()
    #$outputmsg = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit() | Out-Null
    
    if ($errmsg.Length -ne 0) {
        Update-Log -logtype "ERROR" -message $errmsg
    }
}

function Get-PAMPassword ($userid)
{   
    $uid = $($userid -replace ".*\\").Trim()
    $certThumbprint = "33d3b8bbef3b4297594ecb356f71f73ccca7d509"                      #Replace the certificate thumbprint
    $certPath = "Cert:\LocalMachine\My\" + $certThumbprint
    $myCert = Get-ChildItem -Path $certPath
    $appID = "CCP_ITM_ba"                                                           #Replace with AppID
    $safe = "ITM_applications_ba"                                                   #Replace with vault name
    $url = "https://rb-pam-aim.bosch.com/AIMCertAuth/api/Accounts?AppID=$appID&Safe=$safe&UserName=$uid"
    $password = Invoke-RestMethod -Uri $url -Method GET -ContentType "application/json" -Certificate $myCert
    $password.Content.Trim()
}

function Invoke-SqlComand ($SqlQuery) {
    #Write-Host $SqlQuery
    $Global:sqlCommmand.CommandText = $sqlQuery
    $Global:sqlCommmand.ExecuteNonQuery() | Out-Null
}

function Get-SNAFileInDB ($TableName) {
    $checkQuery = "SELECT SNAFileName FROM $TableName"
    $Global:sqlCommmand.CommandText = $checkQuery
    
    $sqlDataAdapter = [System.Data.SqlClient.SqlDataAdapter]::new($Global:sqlCommmand)
    $dataTable = [System.Data.DataTable]::new()
    $sqlDataAdapter.Fill($dataTable) | Out-Null
    return $dataTable
}

function Get-SNAFile {
    [CmdletBinding()]
    Param
    (
        # SNA file share path
        [Parameter(Mandatory = $true,
            Position = 0)]
        [string]
        $path
    )

    Begin {
        $startdate = [datetime]::new(2021, 12, 01)            #Date filter for SNA files which are created after 1.12.2021
    }

    Process {
        if ($Global:ShareUserName -in 'de\bu22ba', 'de\BMS6BA', 'de\bmb2ba', 'ba00fb01\b4mData') {
            $Global:ShareUserPassword = $(Get-PAMPassword -userid $Global:ShareUserName) 
        }
    
        try {
            Invoke-Process -command "net" -arguments "use $path /u:$Global:ShareUserName $Global:ShareUserPassword"
            #net use $path /u:$Global:ShareUserName $Global:ShareUserPassword 2>$null | Out-Null
            
            if (Test-Path $path) {
                Get-ChildItem -Path $path -Filter "*.sna" | ForEach-Object {
                    $currentTime = [datetime]::Now.AddHours(-6)           #Getting the files which are created before 6hrs from currenttime
                    $creationTime = $PSItem.CreationTime
                    $fileName = $PSItem.FullName
           
                    if (($creationTime -gt $startdate) -and ($creationTime -lt $currentTime)) {
                        if ($fileName -in $Global:SNAFileScanQueueTableData.SNAFileName) {
                            #Write-Verbose "SNA File already exists in SNAScanQueue table..." -Verbose
                            
                            return
                        }

                        if ($fileName -in $Global:SNAScanResultTableData.SNAFileName) {
                            #Write-Verbose "SNA File already exists in SNAScanResult table..." -Verbose
                            return
                        }

                        if ($fileName -in $Global:SNAFiles) {
                            #Write-Verbose "SNA File already exists in SNAScanQueue table..." -Verbose
                            return
                        }
                        
                        $insertquery = "INSERT INTO $Global:SNAFileScanQueueTable
                                ([ComponentID]
                                ,[SNAFileName]
                                ,[SharePath]
                                ,[ShareuserName]
                                ,[ScannerSystemName]
                                ,[ScanStatus])
                            VALUES
                                ('$($Global:ComponentID)'
                                ,'$($fileName)'
                                ,'$($Global:SNAFileSharePath)'
                                ,'$($Global:ShareUserName)'
                                ,'$($null)'
                                ,'$($null)')"
                                        
                        Invoke-SqlComand -SqlQuery $insertquery                        

                        $Global:SNAFiles += $fileName                        
                    }
                }
            }
            else {
                Update-Log -logtype "INFO" -message "ComponentID : $($Global:ComponentID) Path : $($path) is not accessible"
            }
        }

        catch {
            Update-Log -logtype "ERROR" -message $PSItem.Exception
        }
    }

    End {
        Invoke-Process -command "net" -arguments "use $('{$path}') /delete"
        #net use $path /delete 2>$null | Out-Null
    }
}

function Get-ComponentDetail ($interfaceFile) {
    $interfaceFileContent = $(Get-Content $interfaceFile)
    $componentID = $($interfaceFileContent -match "^Id=(.*)$" -replace "Id=").Trim()
    $sharepath = $($interfaceFileContent -match "^36485=(.*)$" -replace "36485=")
    $username = $($interfaceFileContent -match "^5003=(.*)$" -replace "5003=")
    $password = $($interfaceFileContent -match "^5004=(.*)$" -replace "5004=")
    $trigger = $($interfaceFileContent -match "^Trigger=(.*)$" -replace "Trigger=")
    
    if (($null -ne $sharepath) -and ($sharepath -ne [string]::Empty) -and ($trigger -eq "BeforeUpload")) {
        $sharepath = $($interfaceFileContent -match "^36485=(.*)$" -replace "36485=").Trim()
        return @($componentID, $sharepath, $username, $password)
    }
}

#region MAIN
Update-Log -logtype "INFO" -message "Program Started"

$interfaceuname = '10.16.119.86\interface'
$interfacepass = $(Get-PAMPassword -userid $interfaceuname)

$InterfaceFileRepository = "\\cmd
\interface$"

Invoke-Process -command "net" -arguments "use $InterfaceFileRepository /u:$interfaceuname $interfacepass"
#net use $InterfaceFileRepository /u:$interfaceuname $interfacepass | Out-Null

if ((Test-Path $InterfaceFileRepository) -ne $true) {
    Update-Log -logtype "ERROR" -message "Path : $($InterfaceFileRepository) not found. Program terminated."
    exit
}

######################DB Block Begin###########################
$DBServer = "Ba0vsql01.de.bosch.com"
$DBName = "DB_MAE_CM_SQL"
$Global:SNAScanResultTable = "dbo.T_CM_AV_SNA_File_Scan_Status"
$Global:SNAFileScanQueueTable = "dbo.T_CM_AV_SNA_File_Scan_Queue" 
$Global:SNAFileCollectorTable = "dbo.T_CM_AV_SNA_File_From_NAS_Share"

$dbUserId = "MAE_CM_INTERFACE"
$dbPassword = $("'$(Get-PAMPassword -userid $dbUserId)'")
$sqlConn = [System.Data.SqlClient.SqlConnection]::new()
$sqlConn.ConnectionString = "Server=$DBServer;Initial Catalog=$DBName;User Id=$dbUserId;Password=$dbPassword"

try {
    $sqlConn.Open() 
}

catch {
    $errorMessage = "SQL Connection Error : $PSItem.Exception"
    Update-Log -logtype "SQLError" -message $errorMessage
    #Write-Host $errorMessage
    exit
}

$Global:sqlCommmand = [System.Data.SqlClient.SqlCommand]::new()
$Global:sqlCommmand.Connection = $sqlConn
###############################################################

$Global:StartDateFilterForInterfaceFile = [datetime]::new(2021, 01, 01)

$Global:ComponentID = $null
$Global:SNAFileSharePath = $null
$Global:ShareUserName = $null
$Global:ShareUserPassword = $null

$Global:SNAFiles = @()                                                                                   #Storing newly found SNA files
$Global:SNAFileScanQueueTableData = $(Get-SNAFileInDB -TableName $Global:SNAFileScanQueueTable)          #Used for storing the available files from SNA Scan Queue table for comparison
$Global:SNAScanResultTableData = $(Get-SNAFileInDB -TableName $Global:SNAScanResultTable)                #Used for storing the available files from SNA Scan Result table for comparison

Get-ChildItem -Path $InterfaceFileRepository -Recurse -Filter "*.ini" | ForEach-Object {
    $interfaceFileName = $PSItem.FullName
    $interfaceFileCreationDate = $PSItem.CreationTime
    $interfaceFileChangeDate = $PSItem.LastWriteTime
    $interfaceFileChangeDateFilter = [datetime]::Now.AddDays(-4)     #set date filter for 4 days before, to check the interface files which are changed after that
    
    if (($interfaceFileCreationDate -ge $Global:StartDateFilterForInterfaceFile) -and (($interfaceFileCreationDate -ge $interfaceFileChangeDate) -or ($interfaceFileChangeDate -ge $interfaceFileChangeDateFilter))) {
        #Write-Host $interfaceFileName
        $componentDetails = $(Get-ComponentDetail -interfaceFile $interfaceFileName)
				
        if ($null -ne $componentDetails) {
            $Global:ComponentID = $componentDetails[0]
            $Global:SNAFileSharePath = $componentDetails[1]
            $Global:ShareUserName = $componentDetails[2]
            $Global:ShareUserPassword = $componentDetails[3]
			
            Get-SNAFile -path $Global:SNAFileSharePath
        }
    }
}

######################DB Block End#############################
$sqlConn.Close()
$sqlConn.Dispose()
###############################################################
Invoke-Process -command "net" -arguments "use $InterfaceFileRepository /delete"
#net use $InterfaceFileRepository /delete | Out-Null
#$totalFiles = $Global:SNAFiles.Count
#$Global:SNAFiles | Out-GridView -Title "Total Files : $totalFiles"
Update-Log -logtype "INFO" -message "Program Completed"

#endregion