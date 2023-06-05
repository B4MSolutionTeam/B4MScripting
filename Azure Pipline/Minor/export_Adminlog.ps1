



function export_AdminLog($path)
{
    create_INI_file($path)
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\Adminlog.ini"
        
        
        $list_file = (Get-ChildItem -Path $path).Name
        
        if($list_file -contains "Adminlog.csv")
        {
            $path_ComponentTypeXML = $path+"\Adminlog.csv"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -lt 0)
            {
                Write-Host("Adminlog.csv file is null")
            }
        }
        else {
            Write-Host("No Adminlog.csv file is exported")
        }
    
    }
    catch {
        Write-Host("Export Admin Log Function Fail")
    }
}

function create_INI_file($path)
{
    $ini_file = @"
    [Common]
    ReportType=Adminlog
    ExportFile=D:\Test\Adminlog.csv
    [Filter]
    LastXDays=20
    [User]
    Account=tad6hc
    Password=Haha050399@@@
    Domain=APAC
"@
    if (Test-Path -Path ($path+"\Adminlog.ini"))
    {
        $ini_file | Out-File -FilePath ($path+"\Adminlog.ini")
    }
    else
    {
        $ini_file | Out-File -FilePath ($path+"\Adminlog.ini")
    }
    
}

$path_folder = "D:\Test"
if(Test-Path -Path $path_folder)
{
    export_AdminLog($path_folder)
}
else
{
    New-Item -Path $path_folder -ItemType Directory
    export_AdminLog
}
