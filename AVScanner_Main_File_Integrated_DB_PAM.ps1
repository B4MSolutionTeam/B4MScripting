<#
    AvScanner - Integrated file with all of the below modules V.3.2
    ################################################################
    1. Script will check the DB Queue for any available SNA file scan job and process it.
    2. Details will be stored to DB
    3. Implemented PAM vault password retreival
    4. Updated PAM vault with additional security measure(certificate thumbprint) for password retreival.
#>


#################Log Files###############

$logFile = "C:\Windows\Temp\AV_Scanner_Logs.txt"

########################################

class SNAScanAlertDetails {
    [string] $ComponentID
    [string] $SNAFileName
    [string] $SEPMessage

    SNAScanAlertDetails($ComponentID, $SNAFileName, $SEPMessage) {
        $this.ComponentID = $ComponentID
        $this.SNAFileName = $SNAFileName 
        $this.SEPMessage = $SEPMessage
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

function Send-ScanAlertMail ($MailContent) {
    $emailServer = "rb-smtp-int.bosch.com"
    $from = "$env:COMPUTERNAME@de.bosch.com"
    $to = "Viswanathan.Seetharaman@in.bosch.com","andre.hasselmann@de.bosch.com"

    $htmlBody = $MailContent | ConvertTo-Html -Head "<style> table , th,  tr, td {border: 1px solid black; border-collapse: collapse;width: auto; white-space: nowrap;}</style>"

    Send-MailMessage -Subject "!!!ALERT!!!Affected File" -Body "$htmlBody*********************END OF MAIL*****************" -BodyAsHtml -From $from -To $to -SmtpServer $emailServer
}

function Get-SEPScan {   
    $SNAFileDetail = $(Get-Item $Global:SNAFileName)
    $SNAfilecreationdate = $($SNAFileDetail.CreationTime)
    $SNAfilesize = $(($SNAFileDetail.Length) / 1MB)

    Stop-Process -Name "*snapshot*" -Force | Out-Null
    Start-Process -FilePath $SnapShot -ArgumentList "$Global:SNAFileName -VQ X:" -WindowStyle Hidden    
    Start-Sleep 40                                                                     #Halting the process for mounting the drive  

    $driveInfo = [System.IO.DriveInfo]::GetDrives().Name

    if ($driveInfo.Contains("X:\") -eq $false) {
        "Error in mounting the drive :$($Global:SNAFileName). Error : $($PSItem.Exception)" >> $logFile
        #Write-Verbose -Message "Error in mounting the file : $Global:SNAFileName" -Verbose
        Stop-Process -Name "*snapshot*" -Force | Out-Null
        $Global:ScanStatus = 1
        return
    }
        
    $scanStartTime = [datetime]::Now
    $scanProcess = Start-Process -FilePath $SEPScanner -ArgumentList "/ScanName B4MAvScanJob" -PassThru -WindowStyle Hidden                              #SEP argument modified as custom scan job "/ScanName B4MAvScanJob" instead of "/ScanDrive X"
    $scanProcess.WaitForExit()

    if ($LASTEXITCODE -ne 0) {
        "Error in scanning the drive. SNA File : $($Global:SNAFileName) Error : $($PSItem.Exception)" >> $logFile
        $Global:ScanStatus = 2
        return
    }

    $Global:ScanStatus = 3

    Start-Sleep 20
    Get-EventLog -LogName 'Symantec Endpoint Protection Client' -After $scanStartTime | ForEach-Object {
        
        $message = $PSItem.Message.Trim()
        $eventID = $PSItem.EventID
        $entryType = $PSItem.EntryType
        $logdate = $PSItem.TimeGenerated
        $isaffected = 0

        if ($eventID -in $SEPEventIdList) {
            $ScannedFiles = 0
            $Risks = 0
            $FilesOmitted = 0
            $TrustedFilesIgnored = 0
            $scanResultPattern = "Scan Complete:  Risks: (\d+)   Scanned: (\d+)   Files/Folders/Drives Omitted: (\d+) Trusted Files Skipped: (\d+)"
        
            if ($message -match $scanResultPattern) {
                $ScannedFiles = $Matches[2]
                $Risks = $Matches[1]
                $FilesOmitted = $Matches[3]
                $TrustedFilesIgnored = $Matches[4]
            } 

            if ($eventID -eq 51) {
                $isaffected = 1
                $AlertDetails = $([SNAScanAlertDetails]::new($Global:ComponentID, $Global:SNAFileName, $message))

                #Send-ScanAlertMail -MailContent $AlertDetails           #Disabled on 07.10.2022
            }
              
            $insertquery = "INSERT INTO $Global:SNAScanResultTable
                       ([ComponentID]
                       ,[SystemIP]
                       ,[SNAFileName]
                       ,[FileCreationDateTime]
                       ,[SNAFileSize_MB]
                       ,[ScanDate]
                       ,[SEPEntryType]
                       ,[SEPMessage]
                       ,[SEPEventID]
                       ,[TotalScannedFiles]
                       ,[Risks]
                       ,[FilesOmitted]
                       ,[TrustedFilesIgnored]
                       ,[IsSNAFileAffected])
                 VALUES
                       ('$($Global:ComponentID)'
                       ,'$($Global:SystemIP)'
                       ,'$($Global:SNAFileName)'
                       ,'$($SNAfilecreationdate)'
                       ,'$([Convert]::ToDouble($SNAfilesize))'
                       ,'$($logdate)'
                       ,'$($entryType)'
                       ,'$($message)'
                       ,'$([Convert]::ToByte($eventID))'
                       ,'$([Convert]::ToInt32($ScannedFiles))'
                       ,'$([Convert]::ToInt32($Risks))'
                       ,'$([Convert]::ToInt32($FilesOmitted))'
                       ,'$([Convert]::ToInt32($TrustedFilesIgnored))'
                       ,'$([Convert]::ToByte($isaffected))')"

            Invoke-SqlCommand -SqlQuery $insertquery
        }
    }
     
    $unmountDrive = Start-Process -FilePath $SnapShot -ArgumentList " --unmount" -WindowStyle Hidden -PassThru
    $unmountDrive.WaitForExit()
    Start-Sleep 20
}

function Get-SNAFile {
    If ($Global:ShareUserName -in 'de\bu22ba', 'de\BMS6BA', 'de\bmb2ba', 'ba00fb01\b4mData') {
        $Global:ShareUserPassword = $(Get-PAMPassword -userid $Global:ShareUserName) 
    }

    try {
        net use $Global:SNAFileSharePath /u:$Global:ShareUserName $Global:ShareUserPassword 2>>$logFile | Out-Null

        if (Test-Path $Global:SNAFileSharePath) {
            $Global:SNAFileName -match "\\(\d+.\d+.\d+.\d+).*" | Out-Null
            $Global:SystemIP = $Matches[1]
          
            if ((Test-Path $Global:SNAFileName) -eq $true) {
                Get-SEPScan    
            }
            else {
                "SNA File : $Global:SNAFileName not found..." >> $logFile
                $Global:ScanStatus = 4
            }               
   
            net use $Global:SNAFileSharePath /delete 2>>$logFile | Out-Null
        }

        else {
            "ComponentID : $($Global:ComponentID) Path : $($Global:SNAFileSharePath) is not accessible" >> $logFile
            $Global:ScanStatus = 4
        }
    }

    catch {
        $PSItem.Exception >> $logFile
        $Global:ScanStatus = 4
        Stop-Process -Name "*snapshot*" -Force | Out-Null
    }

    finally {
        $updateQueueQuery = "UPDATE $Global:SNAFileScanQueueTable
                             SET ScanStatus = '$([Convert]::ToByte($Global:ScanStatus))'
                             WHERE SNAFileName = '$($Global:SNAFileName)'"

        Invoke-SqlCommand -SqlQuery $updateQueueQuery
    }
}

function Invoke-SqlCommand ($sqlQuery) {
    $sqlCommmand = [System.Data.SqlClient.SqlCommand]::new()
    $sqlCommmand.Connection = $sqlConn1
    $sqlCommmand.CommandText = $sqlQuery
    $sqlCommmand.ExecuteNonQuery() | Out-Null
    $sqlCommmand.Dispose()
}

function Invoke-SqlReader ($SqlQuery) {
    $Global:sqlCommmand.CommandText = $SqlQuery
    $DataReader = $Global:sqlCommmand.ExecuteReader()
    
    while ($DataReader.Read()) {
        $Global:ComponentID = $DataReader["ComponentID"].ToString()
        $Global:SNAFileName = $DataReader["SNAFileName"].ToString()
        $Global:SNAFileSharePath = $DataReader["SharePath"].ToString()
        $Global:ShareUserName = $DataReader["ShareUserName"].ToString()

        Get-SNAFile
    }

    $DataReader.Close()
}

function Get-LastScanStatus {
    $LastScanJobQuery = "SELECT * FROM $Global:SNAFileScanQueueTable
                         WHERE ScannerSystemName = '$($env:COMPUTERNAME)' AND ScanStatus = 0"

    Invoke-SqlReader -SqlQuery $LastScanJobQuery
}

function Get-SNAFileFromDB ($TableName) {
    $SNAFileQuery = "BEGIN TRANSACTION
                     WAITFOR DELAY '00:00:05'
                     SELECT TOP(1) * FROM $TableName
                     WITH (TABLOCK, HOLDLOCK)
                     WHERE ScannerSystemName = ''
                     UPDATE TOP(1) $TableName
                     SET [ScannerSystemName] = HOST_NAME()
                     WHERE ScannerSystemName like ''
                     COMMIT"

    Invoke-SqlReader -SqlQuery $SNAFileQuery
}

function Get-SNAFileQueueCount {
    $checkQuery = "SELECT COUNT(*) AS 'JobCount' FROM $Global:SNAFileScanQueueTable
                   WHERE ScannerSystemName = ''"

    $Global:sqlCommmand.CommandText = $checkQuery
    $DataReader = $Global:sqlCommmand.ExecuteReader()
    
    $recordCount = 0

    while ($DataReader.Read()) {
        $recordCount = [Convert]::ToInt64($DataReader["JobCount"].ToString())
    }

    $DataReader.Close()
    return $recordCount   
}

#region MAIN

#SEP Scanner eventid : 2- result, 6 - Warning and 51 - Error messages
$SEPEventIdList = @(2, 6, 51)

$SEPScanner = "C:\Program Files (x86)\Symantec\Symantec Endpoint Protection\DoScan.exe"
$SnapShot = "D:\Images\1.49_19043\snapshot.exe"

if ((Test-Path $SEPScanner) -ne $true) {
    "Symantec Endpoint Protection client not installated..." >> $logFile
    exit
}

if ((Test-Path $SnapShot) -ne $true) {
    "SnapShot tool not found..." >> $logFile
    exit
}

###################### DB Block Begin ###########################

$DBServer = "Ba0vsql01.de.bosch.com"
$DBName = "DB_MAE_CM_SQL"
$dbUserId = "MAE_CM_INTERFACE"
$dbPassword = $(Get-PAMPassword -userid $dbUserId)

$ConnectionString = "Server=$DBServer;Initial Catalog=$DBName;User Id=$dbUserId;Password=$dbPassword"
$Global:SNAScanResultTable = "dbo.T_CM_AV_SNA_File_Scan_Status"
$Global:SNAFileScanQueueTable = "dbo.T_CM_AV_SNA_File_Scan_Queue" 

$sqlConn = [System.Data.SqlClient.SqlConnection]::new()                    #Connection for Datareader, ExecuteQuery(Select statement)
$sqlConn1 = [System.Data.SqlClient.SqlConnection]::new()                   #Connection for ExecuteNonQuery(DML statements)
$sqlConn.ConnectionString = $ConnectionString
$sqlConn1.ConnectionString = $ConnectionString

try {
    $sqlConn.Open() 
    $sqlConn1.Open()
}

catch {
    $errorMessage = "SQL Connection Error : $PSItem.Exception"
    $errorMessage >> $logFile
    #Write-Host $errorMessage
    exit
}

$Global:sqlCommmand = [System.Data.SqlClient.SqlCommand]::new()
$Global:sqlCommmand.Connection = $sqlConn
$Global:sqlCommmand.CommandTimeout = 0   #Setting infinite timeout

################################################################

$Global:ComponentID = $null
$Global:SystemIP = $null
$Global:SNAFileSharePath = $null
$Global:SNAFileName = $null
$Global:ShareUserName = $null
$Global:ShareUserPassword = $null
$Global:ScanStatus = 0

#Block to check and resume the previous scan pending job after system restart(force / schdeuled)
Get-LastScanStatus

#Block to execute regular scan from ScanJobQueue
while ($true) {
    if ($(Get-SNAFileQueueCount) -gt 0) {
        Get-SNAFileFromDB -TableName $Global:SNAFileScanQueueTable   
    }

    else {
        Start-Sleep -Seconds 10
    }
}

###################### DB Block End #############################

$sqlConn.Close()
$sqlConn.Dispose()
$sqlConn1.Close()
$sqlConn1.Dispose()

################################################################

#endregion