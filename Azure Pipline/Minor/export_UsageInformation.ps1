function export_UsageInformation($path)
{
    create_INI_file($path)
    try {
        D:\vdClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\Usageinfo.ini"
        $list_file = (Get-ChildItem -Path $path).Name
        if($list_file -contains "UsageInformation.json")
        {
            $path_ComponentLogCSV = $path+"\UsageInformation.json"
            $size_ComponentLogCSV = (Get-Item -Path $path_ComponentLogCSV).Length
            if($size_ComponentLogCSV -lt 0)
            {
                Write-Host("The UsageInformation.json is null")
            }
        }
        else
        {
            Write-Host("No UsageInformation.json file is exported")
        }
    }
    catch {
        Write-Host(("Export Usage Information is failed to export"))
    }
}

function create_INI_file($path)
{
    $INI_String = @"
    [Common]
    ReportType=UsageInformation
    ExportFile=D:\Test\UsageInformation.json
    
    [User]
    Account=tad6hc
    Password=Haha050399@@@
    Domain=APAC

"@
    if(Test-Path -Path ($path+"\Usageinfo.ini"))
    {
        $INI_String | Out-File -FilePath ($path+"\Usageinfo.ini")
    }
    else {
        $INI_String | Out-File -FilePath ($path+"\Usageinfo.ini")
    }
}
$path = "D:\Test"
if(Test-Path -Path $path)
{
    export_UsageInformation($path)
}
else {
    New-Item -Path $path -ItemType Directory
    export_UsageInformation($path)
}