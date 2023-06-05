function export_User_Group($path)
{
    create_INI_file($path)
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\UserManagement.ini"
        $list_file = (Get-ChildItem -Path $path).Name
        if($list_file -contains "Users.xml")
        {
            $path_ComponentLogCSV = $path+"\Users.xml"
            $size_ComponentLogCSV = (Get-Item -Path $path_ComponentLogCSV).Length
            if($size_ComponentLogCSV -lt 0)
            {
                Write-Host("The Users.xml is null")
            }
            else
            {
                Write-Host("Export User and Group successfull")
            }
        }
        else
        {
            Write-Host("No Users.xml file is exported")
        }
    }
    catch {
        Write-Host(("Export User and Group is failed to export"))
    }
}

function create_INI_file($path)
{
    $INI_String = @"
    [Common]
    ReportType=UserManagement
    ExportFile=D:\Test\Users.xml
    UmGroupedBy="Users"
    
    [User]
    Account=tad6hc
    Password=Haha050399@@@
    Domain=APAC

"@
    if(Test-Path -Path ($path+"\UserManagement.ini"))
    {
        $INI_String | Out-File -FilePath ($path+"\UserManagement.ini")
    }
    else {
        $INI_String | Out-File -FilePath ($path+"\UserManagement.ini")
    }
}
$path = "D:\Test"
if(Test-Path -Path $path)
{
    export_User_Group($path)
}
else {
    New-Item -Path $path -ItemType Directory
    export_User_Group($path)
}