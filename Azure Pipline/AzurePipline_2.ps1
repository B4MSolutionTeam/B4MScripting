
$path_folder = "$(Path_Azure_Test)"
$User = "apac\bmt8hc"
$PWord = ConvertTo-SecureString -String "B4m013209112022@" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord
function export_Job_Result_Difference
{
    param (
        $path
    )
    
    Invoke-Command -ScriptBlock {
        function create_INI_file 
{
    param (
        $path
    )
    $ini_file = @"
    [Common]
    ReportType=UnequalJobResults
    ExportFile=$path\myJobReportDifference.csv
    Dir=\
     
    [User]
    Account=tad6hc
    Password=Haha050399@@@
    Domain=APAC
"@
    $ini_file | Out-File -FilePath ($path+"\exportJobResultDifference.ini")
}
    create_INI_file $path
    }
    $status_update = "failed"
    
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:$path\exportJobResultDifference.ini"
        $list_file = (Get-ChildItem -Path $path).Name
        if($list_file -contains "myJobReportDifference.csv")
        {
            $path_ComponentTypeXML = $path+"\myJobReportDifference.csv"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -lt 0)
            {
                Write-Host("myJobReportDifference.csv file is null")
                $status_update = "failed"
            }
            else
            {
                Write-Host("Export Job Result Different successful")
                $status_update = "passed"
            }
        }
        else {
            Write-Host("No myJobReportDifference.csv file is exported")
            $status_update = "failed"
        }
    
    }
    catch {
        Write-Host("Export Job Result Diffrenent Function Fail")
        $status_update = "failed"
    }

    Start-Sleep 3
    Remove-Item "$path\*"
    return $status_update
}

$status_return = Invoke-Command -ComputerName "BA0VM153.de.bosch.com" -ScriptBlock ${Function:export_Job_Result_Difference} -ArgumentList $path_folder -Credential $Credential
$pat = "e3x5b6ler2dksl44o7dgquhnh5s2k6nqomltnbdjuhligflpyy6a"
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$pat"))
$header = @{
    authorization = "Basic $token"
}
$url = "https://dev.azure.com/B4MService/Software%20Upgrading/_apis/testplan/plans/1/Suites/101/TestPoint?api-version=7.0"
$body = @"
[{
    "id": $(S_Exporting_Job_Result_Different),
    "results": {
    "outcome": "$status_return"
    }
}]
"@
Write-Host "ID: $(S_Exporting_Job_Result_Different)"
Write-Host "Status return: $status_return"
Invoke-RestMethod -Method Patch -Uri $url -Proxy "http://rb-proxy-sl.bosch.com:8080" -Headers $header -Body $body -ContentType "application/json"