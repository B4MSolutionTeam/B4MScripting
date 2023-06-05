



function export_Standard_Libary_Management($path)
{
    create_INI_file($path)
    try {
        D:\vdClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\StandardLibraryManagement.ini"
        
        
        $list_file = (Get-ChildItem -Path $path).Name
        
        if($list_file -contains "StandardLibraryManagement.csv")
        {
            $path_ComponentTypeXML = $path+"\StandardLibraryManagement.csv"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -lt 0)
            {
                Write-Host("StandardLibraryManagement.csv file is null")
            }
        }
        else {
            Write-Host("No StandardLibraryManagement.csv file is exported")
        }
    
    }
    catch {
        Write-Host("Export Standard Library Management Function Fail")
    }
}

function create_INI_file($path)
{
    $ini_file = @"
    [Common]
    ReportType=StandardLibraryManagement
    ExportFile=D:\Test\StandardLibraryManagement.csv
    [User]
    Account=tad6hc
    Password=Haha050399@@@
    Domain=APAC

"@
    if (Test-Path -Path ($path+"\StandardLibraryManagement.ini"))
    {
        $ini_file | Out-File -FilePath ($path+"\StandardLibraryManagement.ini")
    }
    else
    {
        $ini_file | Out-File -FilePath ($path+"\StandardLibraryManagement.ini")
    }
    
}

$path_folder = "D:\Test"
if(Test-Path -Path $path_folder)
{
    export_Standard_Libary_Management($path_folder)
}
else
{
    New-Item -Path $path_folder -ItemType Directory
    export_Standard_Libary_Management
}
