$Component_Tree_Folder = "D:\PowerBi_Import\Component_Tree"
$Job_List_Folder = "D:\PowerBi_Import\Job_List"
function copy_file($List_Path)
{
    $export_folder = "D:\Shares\vDogReports\AutoImport"
    $Component_Tree_Folder = $List_Path[0]
    $Job_List_Folder = $List_Path[1]
    $xml_file_list = Get-ChildItem -Path $export_folder "*xml"
    $csv_file_list = Get-ChildItem -Path $export_folder "*csv"
    $xml_file_list_import = Get-ChildItem -Path $Component_Tree_Folder "*xml"
    $csv_file_list_import = Get-ChildItem -Path $Job_List_Folder "*csv"

    if($csv_file_list_import.Length -eq 0)
    {
        foreach($csv_file in $csv_file_list )
        {
            Copy-Item -Path "$export_folder\$csv_file" -Destination $Job_List_Folder
        }
    }
    else {
        foreach($csv_file in $csv_file_list )
        {
            Remove-Item -Path "$Job_List_Folder\$csv_file"
            Copy-Item -Path "$export_folder\$csv_file" -Destination $Job_List_Folder
        }
        
    }
    if($xml_file_list_import.Length -eq 0)
    {
        foreach($xml_file in $xml_file_list)   
        {
            Copy-Item -Path "$export_folder\$xml_file" -Destination $Component_Tree_Folder
        }
    }
    else {
        foreach($xml_file in $xml_file_list)
        {
            Remove-Item -Path "$Component_Tree_Folder\$xml_file"
            Copy-Item -Path "$export_folder\$xml_file" -Destination $Component_Tree_Folder
        }
    }
    
    
}
function modified_ComponentTree_Data($Component_Tree_Folder)
{
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

function modified_Joblist($Job_List_Folder) {
    $array_csv_file = Get-ChildItem -Path $Job_List_Folder "*csv"
    foreach($csv_file in $array_csv_file)
    {
        $path_csv = $Job_List_Folder + "\" + $csv_file
        $data_csv = Get-Content $path_csv
        $data_csv_array_temp = @()
        for ($j = 0; $j -lt $data_csv.Count; $j++) {
            $replace_string = $data_csv[$j] -replace '"', ''
            $data_csv_array_temp += $replace_string
        }
        $data_csv_array_temp | Out-File $path_csv
    }
}

copy_file($Component_Tree_Folder, $Job_List_Folder)
modified_ComponentTree_Data($Component_Tree_Folder)
modified_Joblist($Job_List_Folder)