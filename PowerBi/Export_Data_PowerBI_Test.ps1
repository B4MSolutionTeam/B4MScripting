
function create_INI_ComponentTree($Ini_data)
{
    $report_type = $Ini_data[0]
    $export_file = $Ini_data[4]
    $with_version = $Ini_data[1]
    $with_master_data = $Ini_data[2]
    $enable_node_tree = $Ini_data[3]
    $dir = $Ini_data[5]
    $ini_file = "[Common]
ReportType=$report_type
ExportFile=$export_file.xml
WithVersions=$with_version
WithMasterData=$with_master_data
EnableNodeTree=$enable_node_tree
Dir=$dir
"
    $ini_path = $Ini_data[4] + ".ini"
    Set-Content -Path $ini_path -Value $ini_file 
    return $ini_path
}

function export_ComponenTree_Data
{
    param(
        $InI_ComponentTree_Data, $password
    )
    for($i=0; $i -lt $InI_ComponentTree_Data[0].Count; $i++)
    {
        $ini_path = $InI_ComponentTree_Data[0][$i]
        D:\vdClient\vdogautoexport.exe "/rd:D:\vdCA" "/CFile:$ini_path" /Account:bmt8hc /Password:$password /Domain:APAC
    }

}
function modified_ComponentTree_Data
{
    param(
        $list_file_xml
    )
    for ($i = 0; $i -lt $list_file_xml.Count; $i++) {
        $line_error = 0
        $position_error = 0
        $array_temp = @()
        $path_xml = "D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni\"+$list_file_xml[$i]
        Write-Host("Path "+ $path_xml)
        $check_valid_xml_file = $true 
        while ($check_valid_xml_file -eq $true) {
            try {
                [xml]$xml_content = Get-Content -Path $path_xml
                $xml_content.root.Component.Versions.Version | Where-Object {($_.ChangeReason).Length -ge 0} | ForEach-Object {$_.RemoveAttribute("ChangeReason")}
                $xml_content.root.Component.Versions.Version | Where-Object {($_.Comment).Length -ge 0} | ForEach-Object {$_.RemoveAttribute("Comment")}
                Start-Sleep 1
                Remove-Item -Path $path_xml
                $xml_content.Save($path_xml)
                $check_valid_xml_file = $false
            }
            catch {
                $error_detail = $_.Exception.Message
                if($error_detail.Contains("invalid character"))
                {
                    $error_sentence = $error_detail.Replace('"',"")
                    $array_sentence = $error_sentence.Split(".")
                    $line_position_error = $array_sentence[-2].Split(",")
                    for ($i = 0; $i -lt $line_position_error.Count; $i++) {
                        $modified_line_position_error = $line_position_error[$i].Split(" ")
                        $array_temp += $modified_line_position_error[2]
                    }
                }
                elseif ($error_detail.Contains("You cannot call a method on a null-valued expression.")) {
                    break
                }
                $check_valid_xml_file = $true

                $line_error = [int]($array_temp[0])
                $position_error = [int]($array_temp[1])
                $xml_content = Get-Content -Path $path_xml
                $array_data_xml_file = @() 
                for ($j = 0; $j -lt $xml_content.Count; $j++) {
                    if($j -eq $line_error-1)
                    {
                        $modified_string_error = ($xml_content[$j])
                        $modified_string_error = $modified_string_error.Remove($position_error-1,1)
                        Write-Host($modified_string_error)
                        $array_data_xml_file += $modified_string_error
                    }
                    else {
                        $array_data_xml_file += $xml_content[$j]
                    }
                }
                Remove-Item -Path $path_xml
                $array_data_xml_file | Out-File -Encoding utf8 -FilePath $path_xml
            }
        }



    }
    
}

function remove_Component_Needed_XML
{
    param(
        $list_file_xml
    )
    $path_id_remove = "$((Get-Location).Path)\remove_component.txt"
    $list_id_remove = Get-Content -Path $path_id_remove
    
    foreach($xml_file in $list_file_xml)
    {
        $path_xml = "D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni\$xml_file"
        $xml_content = [xml](Get-Content -Path $path_xml)
        $list_ComponentID_remove = @()
        foreach($id_remove in $list_id_remove)
        {
            $list_ComponentID_remove += $xml_content.root.Component | Where-Object {($_.TypeId) -eq "$id_remove"} | Select Id
        }
        foreach($id in $list_ComponentID_remove.Id)
        {
            Write-Host("Path Node: //Component[@Id='$id']")
            $node = $xml_content.SelectSingleNode("//Component[@Id='$id']")
            $node.ParentNode.RemoveChild($node)
        }
        Remove-Item -Path $path_xml
        $xml_content.Save($path_xml)
    }
}

function delete_ComponentTree_Data_Ini
{
    param(
        $Ini_ComponentTree_Data
    )
    for($i=0; $i -lt $Ini_ComponentTree_Data[0].Count; $i++)
    {
        $ini_path = $Ini_ComponentTree_Data[0][$i]
        Remove-Item $ini_path
    }
    $array_list_file_xml = Get-ChildItem -Path D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni | Where-Object { $_.Extension -in '.xml'}
}
function create_INI_ComponentTree($Ini_data)
{
    $report_type = $Ini_data[0]
    $export_file = $Ini_data[4]
    $with_version = $Ini_data[1]
    $with_master_data = $Ini_data[2]
    $enable_node_tree = $Ini_data[3]
    $dir = $Ini_data[5]
    $ini_file = "[Common]
ReportType=$report_type
ExportFile=$export_file.xml
WithVersions=$with_version
WithMasterData=$with_master_data
EnableNodeTree=$enable_node_tree
Dir=$dir
"
    $ini_path = $Ini_data[4] + ".ini"
    Set-Content -Path $ini_path -Value $ini_file 
    return $ini_path
}

function export_ComponenTree_Data
{
    param(
        $InI_ComponentTree_Data, $password
    )
    for($i=0; $i -lt $InI_ComponentTree_Data[0].Count; $i++)
    {
        $ini_path = $InI_ComponentTree_Data[0][$i]
        D:\vdClient\vdogautoexport.exe "/rd:D:\vdCA" "/CFile:$ini_path" /Account:bmt8hc /Password:$password /Domain:APAC
    }

}
function modified_ComponentTree_Data
{
    param(
        $list_file_xml
    )
    for ($i = 0; $i -lt $list_file_xml.Count; $i++) {
        $line_error = 0
        $position_error = 0
        $array_temp = @()
        $path_xml = "D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni\"+$list_file_xml[$i]
        Write-Host("Path "+ $path_xml)
        $check_valid_xml_file = $true 
        while ($check_valid_xml_file -eq $true) {
            try {
                [xml]$xml_content = Get-Content -Path $path_xml
                $xml_content.root.Component.Versions.Version | Where-Object {($_.ChangeReason).Length -ge 0} | ForEach-Object {$_.RemoveAttribute("ChangeReason")}
                $xml_content.root.Component.Versions.Version | Where-Object {($_.Comment).Length -ge 0} | ForEach-Object {$_.RemoveAttribute("Comment")}
                Start-Sleep 1
                Remove-Item -Path $path_xml
                $xml_content.Save($path_xml)
                $check_valid_xml_file = $false
            }
            catch {
                $error_detail = $_.Exception.Message
                if($error_detail.Contains("invalid character"))
                {
                    $error_sentence = $error_detail.Replace('"',"")
                    $array_sentence = $error_sentence.Split(".")
                    $line_position_error = $array_sentence[-2].Split(",")
                    for ($i = 0; $i -lt $line_position_error.Count; $i++) {
                        $modified_line_position_error = $line_position_error[$i].Split(" ")
                        $array_temp += $modified_line_position_error[2]
                    }
                }
                elseif ($error_detail.Contains("You cannot call a method on a null-valued expression.")) {
                    break
                }
                $check_valid_xml_file = $true

                $line_error = [int]($array_temp[0])
                $position_error = [int]($array_temp[1])
                $xml_content = Get-Content -Path $path_xml
                $array_data_xml_file = @() 
                for ($j = 0; $j -lt $xml_content.Count; $j++) {
                    if($j -eq $line_error-1)
                    {
                        $modified_string_error = ($xml_content[$j])
                        $modified_string_error = $modified_string_error.Remove($position_error-1,1)
                        Write-Host($modified_string_error)
                        $array_data_xml_file += $modified_string_error
                    }
                    else {
                        $array_data_xml_file += $xml_content[$j]
                    }
                }
                Remove-Item -Path $path_xml
                $array_data_xml_file | Out-File -Encoding utf8 -FilePath $path_xml
            }
        }



    }
    
}

function remove_Component_Needed_XML
{
    param(
        $list_file_xml
    )
    $path_id_remove = "$((Get-Location).Path)\remove_component.txt"
    $list_id_remove = Get-Content -Path $path_id_remove
    
    foreach($xml_file in $list_file_xml)
    {
        $path_xml = "D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni\$xml_file"
        $xml_content = [xml](Get-Content -Path $path_xml)
        $list_ComponentID_remove = @()
        foreach($id_remove in $list_id_remove)
        {
            $list_ComponentID_remove += $xml_content.root.Component | Where-Object {($_.TypeId) -eq "$id_remove"} | Select Id
        }
        foreach($id in $list_ComponentID_remove.Id)
        {
            Write-Host("Path Node: //Component[@Id='$id']")
            $node = $xml_content.SelectSingleNode("//Component[@Id='$id']")
            $node.ParentNode.RemoveChild($node)
        }
        Remove-Item -Path $path_xml
        $xml_content.Save($path_xml)
    }
}

function delete_ComponentTree_Data_Ini
{
    param(
        $Ini_ComponentTree_Data
    )
    for($i=0; $i -lt $Ini_ComponentTree_Data[0].Count; $i++)
    {
        $ini_path = $Ini_ComponentTree_Data[0][$i]
        Remove-Item $ini_path
    }
    $array_list_file_xml = Get-ChildItem -Path D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni\ "*xml"
    return $array_list_file_xml

}

function create_INI_JobList($INI_Data)
{
    $report_type = $INI_Data[0]
    $include_all_component = $INI_Data[1]
    $export_path = $INI_Data[2]
    $dir = $INI_Data[3]
    $ini_file = "[Common]
ReportType=$report_type
IncludeAllComponents=$include_all_component
Dir=$dir
ExportFile=$export_path.csv 
    "
    $ini_path = "$export_path" + ".ini"
    Set-Content -Path $ini_path -Value $ini_file
    return $ini_path
}

function export_JobList_Data
{
    param(
        $INI_JobList_Data_Array, $password
    )
    for ($i = 0; $i -lt $INI_JobList_Data_Array[0].Count; $i++) {
        $ini_path = $INI_JobList_Data_Array[0][$i]
        D:\vdClient\vdogautoexport.exe "/rd:D:\vdCA" "/CFile:$ini_path" /Account:bmt8hc /Password:$password /Domain:APAC
        
    }
    
    for ($i = 0; $i -lt $INI_JobList_Data_Array[1].Count; $i++) {
        $dir_JobList = $INI_JobList_Data_Array[1][$i]
        $data_csv = Get-Content "$dir_JobList.csv"
        $data_csv_array_temp = @()
        for ($j = 0; $j -lt $data_csv.Count; $j++) {
           $replace_string = $data_csv[$j] -replace '"', ''
           $data_csv_array_temp += $replace_string
        }
        $data_csv_array_temp | Out-File "$dir_JobList.csv"
    }
    
}

function remove_Component_Needed_CSV()
{
    $path_csv_file = "D:\Shares\PowerBi_Export_File_Test\JobListIni"
    $list_csv_file = (Get-ChildItem -Path $path_csv_file "*csv").FullName
    
    $path_id_remove = "$((Get-Location).Path)\remove_component.txt"
    $list_id_remove = Get-Content -Path $path_id_remove
    
    foreach($csv_file in $list_csv_file)
    {
        $csv_content = Import-Csv -Path $csv_file -Delimiter ";"
        $temp_csv = @()
        foreach($line in $csv_content)
        {
            if($line.ComponentTypeId -notin $list_id_remove)
            {
                $temp_csv += $line
            }
        }
        $temp_csv | Export-Csv -Delimiter ";" -Path $csv_file -NoTypeInformation
        if((Get-ChildItem -Path $csv_file).Length -eq 0 )
        {
            Remove-Item -Path $csv_file
        }
    }
    $list_csv_file = (Get-ChildItem -Path $path_csv_file "*csv").FullName
    foreach($csv_file in $list_csv_file)
    {
        $data_csv = Get-Content -Path $csv_file
        $data_csv_new = @()
        foreach($line in $data_csv)
        {
            $new_line = $line.Replace('"','')
            $data_csv_new += $new_line
            
        }
        $data_csv_new | Out-File $csv_file
    }
}
function delete_JobList_Data
{
    param(
        $INI_JobList_Data_Array
    )
    for ($i = 0; $i -lt $INI_JobList_Data_Array[0].Count; $i++) {
        $ini_path = $INI_JobList_Data_Array[0][$i]
        Remove-Item $ini_path
    }
    Remove-Item D:\Shares\PowerBi_Export_File_Test\JobListIni\JobList_Ba_HDEV5.csv
}
function prepare_ComponentTree_Data()
{
    $xml_file_list = Get-ChildItem -Path D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni "*xml"
    foreach($xml_file in $xml_file_list)
    {
        Remove-Item -Path "D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni\$xml_file"
    }

    $ComponentTree_Data_JSON = Get-Content -Path D:\Shares\PowerBi_Export_File_Test\ComponentTree.json
    $ComponentTree_Data = $ComponentTree_Data_JSON | ConvertFrom-Json
    $withversion = $ComponentTree_Data.Common.WithVersion
    $reporttype = $ComponentTree_Data.Common.Reportype
    $withmasterdata = $ComponentTree_Data.Common.WithMasterData
    $enablenodetree = $ComponentTree_Data.Common.EnableNodeTree
    $list_dir = $ComponentTree_Data.Dir
    $ini_ComponentTree_Array = @()
    $dir_array = @()
    for ($i = 0; $i -lt $list_dir.Count; $i++) {
        $dir = $list_dir[$i]
        $dir = $dir.Replace("\","_")
        $path_ini = "D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni\ComponentTree{0}" -f $dir
        $array_data = $reporttype, $withversion, $withmasterdata, $enablenodetree, $path_ini, $list_dir[$i]
        $ini_ComponentTree_Array += create_INI_ComponentTree($array_data)
        $dir_array += $path_ini
    }
    return ($ini_ComponentTree_Array, $dir_array)
}

function prepare_JobList_Data()
{
    $csv_file_list = Get-ChildItem -Path D:\Shares\PowerBi_Export_File_Test\JobListIni "*csv"
    
    foreach($csv_file in $csv_file_list )
    {
        Remove-Item -Path "D:\Shares\PowerBi_Export_File_Test\JobListIni\$csv_file"
    }
    $JobList_Data_JSON = Get-Content -Path D:\Shares\PowerBi_Export_File_Test\JobList.json
    $JobList_Data = $JobList_Data_JSON | ConvertFrom-Json
    $reporttype = $JobList_Data.Common.ReportType
    $includeallcomponent = $JobList_Data.Common.IncludeAllComponents
    $list_dir = $JobList_Data.Dir
    $ini_JobList_Array = @()
    $path_JobList_Array = @()
    for ($i = 0; $i -lt $list_dir.Count; $i++) {
        $dir = $list_dir[$i]
        $dir = $dir.Replace("\","_")
        $path_JobList = "D:\Shares\PowerBi_Export_File_Test\JobListIni\JobList{0}" -f $dir
        $array_data = $reporttype, $includeallcomponent, $path_JobList, $list_dir[$i]
        $ini_JobList_Array += create_INI_JobList($array_data)
        $path_JobList_Array += $path_JobList
    }
    return ($ini_JobList_Array, $path_JobList_Array)
}
. "D:\Automation_Script\get_pam_password.ps1"
$password_pam = Get-PAMPassword
$ComponentTree_Array = prepare_ComponentTree_Data
export_ComponenTree_Data -InI_ComponentTree_Data $ComponentTree_Array -password $password_pam
$array_list_file_xml = delete_ComponentTree_Data_Ini -Ini_ComponentTree_Data $ComponentTree_Array
modified_ComponentTree_Data -list_file_xml $array_list_file_xml
remove_Component_Needed_XML -list_file_xml $array_list_file_xml

$JobList_Array = prepare_JobList_Data
export_JobList_Data -INI_JobList_Data_Array $JobList_Array -password $password_pam
delete_JobList_Data -INI_JobList_Data_Array $JobList_Array
remove_Component_Needed_CSV


