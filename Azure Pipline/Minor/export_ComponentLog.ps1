function export_ComponentLog($path)
{
    create_INI_file($path)
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\ComponentLog.ini"
        $list_file = (Get-ChildItem -Path $path).Name
        if($list_file -contains "Componentlog.csv")
        {
            $path_ComponentLogCSV = $path+"\Componentlog.csv"
            $size_ComponentLogCSV = (Get-Item -Path $path_ComponentLogCSV).Length
            if($size_ComponentLogCSV -lt 0)
            {
                Write-Host("The ComponenentLog.csv is null")
            }
        }
        else
        {
            Write-Host("No ComponentLog.csv file is exported")
        }
    }
    catch {
        Write-Host(("Exprt Component Log is failed to export"))
    }
}

function create_INI_file($path)
{
    $INI_String = @"
    [Common]
    ReportType=Componentlog
    ExportFile=D:\Test\Componentlog.csv
    [Filter]
    FilterFrom=2021-4-17T08:12Z
    FilterTo=2021-4-21T18:00Z
    [User]
    Account=TAD6HC
    Password=Haha050399@@@
    Domain=APAC
"@
    if(Test-Path -Path ($path+"\ComponentLog.ini"))
    {
        $INI_String | Out-File -FilePath ($path+"\ComponentLog.ini")
    }
    else {
        $INI_String | Out-File -FilePath ($path+"\ComponentLog.ini")
    }
}
$path = "D:\Test"
if(Test-Path -Path $path)
{
    export_ComponentLog($path)
}
else {
    New-Item -Path $path -ItemType Directory
    export_ComponentLog($path)
}