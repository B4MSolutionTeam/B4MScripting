$Job_List_Folder = "D:\Shares\PowerBi_Export_File_Test\JobListIni_Ora"
$Component_Tree_Folder = "D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni_Ora"
$export_folder = "D:\Shares\vDogReports\AutoImport"
$csv_file_list = (Get-ChildItem -Path $export_folder "*csv").FullName
foreach($csv_file in $csv_file_list)
{
    Copy-Item -Path $csv_file -Destination $Job_List_Folder
}
function modified_JobList_Data {
    param (
        $export_folder
    )
    $list_csv_file = (Get-ChildItem -Path $Job_List_Folder "*csv").FullName
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
function export_ComponentTree_Data
{
    param(
        $password
    )
    $list_xml_file = (Get-ChildItem -Path $Component_Tree_Folder| Where-Object {$_.Extension -in '.xml'}).FullName
    foreach($xml_file in $list_xml_file)
    {
        Remove-Item -Path $xml_file
    }
    $path_json = "D:\Shares\PowerBi_Export_File_Test\ComponentTree.json"
    $data_json = (Get-Content -Raw -Path $path_json) | ConvertFrom-Json 
    $report_type = $data_json.Common.Reportype
    $with_version = $data_json.Common.WithVersion
    $with_master_data = $data_json.Common.WithMasterData
    $enable_node_tree = $data_json.Common.EnableNodeTree
    $list_valustream = $data_json.Dir
    $path_export = "D:\Shares\PowerBi_Export_File_Test\ComponentTreeIni_Ora"
    foreach($valuestream in $list_valustream)
    {
        $content = "[Common]
ReportType=$report_type
ExportFile=$path_export\ComponentTree$($valuestream.Replace("\","_")).xml
WithVersions=$with_version
WithMasterData=$with_master_data
EnableNodeTree=$enable_node_tree
Dir=$valuestream
        "
        Set-Content -Path "$path_export\ComponentTree$($valuestream.Replace("\","_")).ini" -Value $content
    }

    $list_ini_file = (Get-ChildItem -Path $path_export| Where-Object { $_.Extension -in '.ini' }).FullName

    foreach($ini_file in $list_ini_file)
    {
        D:\vdClient\vdogautoexport.exe "/rd:D:\vdCA" "/CFile:$ini_file" /Account:bmt8hc /Password:$password /Domain:APAC
    }

    foreach($ini_file in $list_ini_file)
    {
        Remove-Item -Path $ini_file
    }
}

function modified_ComponentTree_Data
{
    param(
        $Component_Tree_Folder
    )

    $list_xml_file = Get-ChildItem -Path $Component_Tree_Folder "*xml"
    foreach($xml_file in $list_xml_file)
    {
        
        $line_error = 0
        $position_error = 0
        $array_temp = @()
        $path_xml = $Component_Tree_Folder +"\" + $xml_file
        Write-Host($path_xml)
        $check_exception_xml = $true
        while($check_exception_xml -eq $true)
        {
            try {
                [xml]$xml_content = Get-Content -Path "$Component_Tree_Folder\$xml_file"
                $xml_content.root.Component.Versions.Version | Where-Object {($_.ChangeReason).Length -ge 0} | ForEach-Object {$_.RemoveAttribute("ChangeReason")}
                $xml_content.root.Component.Versions.Version | Where-Object {($_.Comment).Length -ge 0} | ForEach-Object {$_.RemoveAttribute("Comment")}
                Start-Sleep 1
                Remove-Item -Path $path_xml
                $xml_content.Save($path_xml)
                $check_exception_xml = $false
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
                elseif ($error_detail.Contains("You cannot call a method on a null-valued expression."))
                {
                    break
                }
                $check_exception_xml = $true

                $line_error = [int]($array_temp[0])
                $position_error = [int]($array_temp[1])
                $xml_content = Get-Content -Path $path_xml
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
. "D:\Automation_Script\get_pam_password.ps1"
$password_pam = Get-PAMPassword
export_ComponentTree_Data -password $password_pam
modified_ComponentTree_Data -Component_Tree_Folder $Component_Tree_Folder
modified_JobList_Data -export_folder $export_folder


