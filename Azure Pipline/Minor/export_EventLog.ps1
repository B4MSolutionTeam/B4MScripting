function export_EventLog($path)
{
    create_INI_file($path)
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\Eventlog.ini"
        $list_file = (Get-ChildItem -Path $path).Name
        if($list_file -contains "Componentlog.csv")
        {
            $path_ComponentLogCSV = $path+"\Componentlog.csv"
            $size_ComponentLogCSV = (Get-Item -Path $path_ComponentLogCSV).Length
            if($size_ComponentLogCSV -lt 0)
            {
                Write-Host("The Eventlog.csv is null")
            }
        }
        else
        {
            Write-Host("No Eventlog.csv file is exported")
        }
    }
    catch {
        Write-Host(("Exprt Event Log Function is failed to export"))
    }
}

function create_INI_file($path)
{
    $INI_String = @"
    [Common]
    ReportType=Eventlog
    ExportFile=D:\Test\Eventlog.csv
    [Filter]
    FilterFrom=
    FilterTo=
    [User]
    Account=tad6hc
    Password=@@@
    Domain=APAC
"@
    if(Test-Path -Path ($path+"\Eventlog.ini"))
    {
        $INI_String | Out-File -FilePath ($path+"Eventlog.ini")
    }
    else {
        $INI_String | Out-File -FilePath ($path+"\Eventlog.ini")
    }
}
$path = "D:\Test"
if(Test-Path -Path $path)
{
    export_EventLog($path)
}
else {
    New-Item -Path $path -ItemType Directory
    export_EventLog($path)
}