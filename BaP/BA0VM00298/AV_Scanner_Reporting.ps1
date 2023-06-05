
$AV_Scanner_Report_CSV = "D:\B4M\Automation\AV_Scanner_Reporting"
function Prepare_Ini_CSV_AVScanner
{
    param(
        $reportPath
    )
    $list_CSV_previous = (Get-ChildItem -Path $reportPath | Where-Object {$_.Extension -in ".csv"}).FullName
    if($list_CSV_previous.Length -gt 0)
    {
        foreach($CSV_file in $list_CSV_previous)
        {
            Remove-Item -Path $CSV_file
        }
    }
    $path_json = "D:\B4M\Automation\Script_Automation\JobList.json"
    $ini_data_list = Get-Content -Raw -Path $path_json | ConvertFrom-Json
    $report_type = $ini_data_list.Common.ReportType
    $include_Component = $ini_data_list.Common.IncludeAllComponents
    foreach($ini_data in $ini_data_list.Dir)
    {
        $valuestream = (([string]$ini_data).Split("\\"))[-1]
        $ini_string = "[Common]
ReportType=$report_type
IncludeAllComponents=$include_Component
Dir=$ini_data
ExportFile=$reportPath\AV_Scanner_CSV_$valuestream.csv
"
        $ini_string | Out-File -FilePath "$reportPath\AV_Scanner_INI_$valuestream.ini"
    }
}

function Export_Data_CSV_AVScanner
{
    param(
        $reportPath, $password
    )
    Write-Host("export start")
    $list_ini_file = (Get-ChildItem -Path $reportPath | Where-Object {$_.Extension -in ".ini"}).FullName
    foreach($ini_file in $list_ini_file)
    {
        D:\B4M\ClientProfile\BMT8HC\vdogClient\VDogAutoExport.exe "/rd:D:\B4M\SA" "/CFile:$ini_file" /Account:bmt8hc /Password:$password /Domain:APAC
    }
    
    foreach($ini_file in $list_ini_file)
    {
        Remove-Item -Path $ini_file
    }
    $list_csv_file = (Get-ChildItem -Path $reportPath | Where-Object {$_.Extension -in ".csv"}).FullName
    foreach($csv_file in $list_csv_file)
    {
        $csv_content = Import-Csv -Path $csv_file -Delimiter

    }
}

. "D:\B4M\Automation\Script_Automation\get_pam_password.ps1"
$password_pam = Get-PAMPassword

Prepare_Ini_CSV_AVScanner -reportPath $AV_Scanner_Report_CSV
Export_Data_CSV_AVScanner -reportPath $AV_Scanner_Report_CSV -password $password_pam    


