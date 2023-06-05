function export_Job_Result($path)
{
    create_INI_file($path)
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:$path\exportJobResults.ini"
        $list_file = (Get-ChildItem -Path $path).Name
        if($list_file -contains "myJobResults.csv")
        {
            $path_ComponentLogCSV = $path+"\myJobResults.csv"
            $size_ComponentLogCSV = (Get-Item -Path $path_ComponentLogCSV).Length
            if($size_ComponentLogCSV -lt 0)
            {
                Write-Host("Job Result File is null")
            }
            else {
                Write-Host("Export Job Result Succes")
            }
        }
        else
        {
            Write-Host("No myJobResults.csv file is exported")
        }
    }
    catch {
        Write-Host("Exprt Job Result is failed to export")
    }
}

function create_INI_file
{
    param(
        $path
    )
    $INI_String = @"
    [Common]
    ReportType=JobResults
    ExportFile=$path\myJobResults.csv
    Dir=\
    [Filter]
    LastXDays=20
    [User]
    Account=BMT8HC
    Password=B4m013209112022@
    Domain=APAC
"@
    $INI_String | Out-File -FilePath "$path\exportJobResults.ini"
   
}
$path = "D:\Test"
if(Test-Path -Path $path)
{
    export_Job_Result($path)
}
else {
    New-Item -Path $path -ItemType Directory
    export_Job_Result($path)
}