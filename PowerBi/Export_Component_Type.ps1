



function export_Component_Type($path)
{
    create_INI_file($path)
    try {
        C:\Users\TAD6HC\Desktop\vdClient\VDogAutoExport.exe "/rd:C:\Users\TAD6HC\Desktop\vdCA" "/CFile:$path\ComponentTypes_Ba.ini"        
        
        
        $list_file = (Get-ChildItem -Path $path).Name
        
        if($list_file -contains "ComponentTypes_Ba.xml")
        {
            $path_ComponentTypeXML = $path+"\ComponentTypes_Ba.xml"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -le 0)
            {
                Write-Host("ComponentType.xml file is null")
            }
            else {
                Write-Host("Component Type export successful")
                
                $path_id_remove = "$((Get-Location).Path)\remove_component.txt"
                $path_ComponentType = "$path\ComponentTypes_Ba.xml"
                $data_xml = [xml](Get-Content -Path $path_ComponentTypeXML)
                $list_id_componenttype = Get-Content -Path $path_id_remove
                $list_ComponentTypeID_XML = @()
                foreach($id_componenttype in $list_id_componenttype)
                {
                    $list_ComponentTypeID_XML += $data_xml.root.ComponentTypes.ComponentType | Where-Object {$_.ID -eq "$id_componenttype"}
                }
                foreach($ComponentTypeID_XML in $list_ComponentTypeID_XML.ID)
                {
                    $node = $data_xml.SelectSingleNode("//ComponentType[@ID='$ComponentTypeID_XML']")
                    $node.ParentNode.RemoveChild($node)
                }
                $data_xml.Save($path_ComponentType)
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
        ExportFile=$path\ComponentTypes_Ba.xml
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

$path_folder = "D:\Shares\PowerBi_Export_File_Test\ComponentType"
if(Test-Path -Path $path_folder)
{
    $list_component_type_file = Get-ChildItem -Path $path_folder "*xml"
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
    $list_component_type_file = Get-ChildItem -Path $path_folder "*xml"
    foreach($component_type_file in $list_component_type_file)
    {
        Remove-Item -Path $path_folder\$component_type_file
    }
    export_Component_Type($path_folder)
    Remove-Item -Path "$path_folder\ComponentTypes_Ba.ini"
}
