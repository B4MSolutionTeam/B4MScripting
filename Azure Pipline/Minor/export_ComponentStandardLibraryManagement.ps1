



function export_Component_Standard_Libary_Management($path)
{
    create_INI_file($path)
    try {
        D:\vdClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\ComponentsWithStdLibAssignments.ini"
        
        
        $list_file = (Get-ChildItem -Path $path).Name
        
        if($list_file -contains "ComponentsWithStdLibAssignments.csv")
        {
            $path_ComponentTypeXML = $path+"\ComponentsWithStdLibAssignments.csv"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -lt 0)
            {
                Write-Host("ComponentsWithStdLibAssignments.csv file is null")
            }
        }
        else {
            Write-Host("No ComponentsWithStdLibAssignments.csv file is exported")
        }
    
    }
    catch {
        Write-Host("Export Component Standard Library Management Function Fail")
    }
}

function create_INI_file($path)
{
    $ini_file = @"
    [Common]
    ComponentsWithStdLibAssignments
    ReportType=ComponentsWithStdLibAssignments
    ExportFile=D:\Test\ComponentsWithStdLibAssignments.csv
    [User]
    Account=tad6hc
    Password=Haha050399@@@
    Domain=APAC

"@
    if (Test-Path -Path ($path+"\ComponentsWithStdLibAssignments.ini"))
    {
        $ini_file | Out-File -FilePath ($path+"\ComponentsWithStdLibAssignments.ini")
    }
    else
    {
        $ini_file | Out-File -FilePath ($path+"\ComponentsWithStdLibAssignments.ini")
    }
    
}

$path_folder = "D:\Test"
if(Test-Path -Path $path_folder)
{
    export_Component_Standard_Libary_Management($path_folder)
}
else
{
    New-Item -Path $path_folder -ItemType Directory
    export_Component_Standard_Libary_Management
}
