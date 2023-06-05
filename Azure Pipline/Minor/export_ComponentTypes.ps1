



function export_Component_Type($path)
{
    create_INI_file($path)
    try {
        C:\Users\TAD6HC\Desktop\vdClient\VDogAutoExport.exe "/rd:C:\Users\TAD6HC\Desktop\vdCA" "/CFile:D:\Test\ComponentType\ComponentTypes_Ba.ini"        
        
        
        $list_file = (Get-ChildItem -Path $path).Name
        
        if($list_file -contains "ComponentTypes.xml")
        {
            $path_ComponentTypeXML = $path+"\ComponentTypes.xml"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -lt 0)
            {
                Write-Host("ComponentType.xml file is null")
            }
        }
        else {
            Write-Host("No ComponentType.xml file is exported")
        }
    
    }
    catch {
        Write-Host("Export Component Type Fail")
    }
}

function create_INI_file($path)
{
    $ini_file = @"
        [Common]
        ReportType=ComponentTypes
        ExportFile=D:\Test\ComponentType\ComponentTypes_Ba.xml
        [User]
        Account=TAD6HC
        Password=Haha050399@@@
        Domain=APAC
"@
    if (Test-Path -Path ($path+"\ComponentTypes_Ba.ini"))
    {
        $ini_file | Out-File -FilePath ($path+"\ComponentTypes_Ba.ini")
    }
    else
    {
        $ini_file | Out-File -FilePath ($path+"\ComponentTypes_Ba.ini")
    }
    
}

$path_folder = "D:\Test\ComponentType"
if(Test-Path -Path $path_folder)
{
    $list_component_type_file = Get-ChildItem -Path D:\Test\ComponentType "*xml"
    foreach($component_type_file in $list_component_type_file)
    {
        Remove-Item -Path $path_folder\$component_type_file
    }
    export_Component_Type($path_folder)
    Remove-Item -Path "$path_folder\ComponentTypes_Ba.ini"
}
else
{
    New-Item -Path $path_folder -ItemType Directory
    $list_component_type_file = Get-ChildItem -Path D:\Test\ComponentType "*xml"
    foreach($component_type_file in $list_component_type_file)
    {
        Remove-Item -Path $path_folder\$component_type_file
    }
    export_Component_Type($path_folder)
    Remove-Item -Path "$path_folder\ComponentTypes_Ba.ini"
}
