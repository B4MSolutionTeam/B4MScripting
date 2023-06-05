$bulk_path = "\\ba00fb02-sl4.de.bosch.com\B4M\Automation\Automation_Script_Report_File"
function Copy-To-Bulk
{
    param(
        $path_report, $path_bulk, $password
    )

    net use $path_bulk /u:APAC\BMT8HC $password
    Copy-Item -Path $path_report -Destination $path_bulk
    net use $path_bulk /delete

}
function get_data_bulk_drive
{
    param(
        $path, $password
    )
    $data = '{
        "data":
        [
            
        ]
    }'
    $list_disk_id = (Get-CimInstance -ClassName Win32_LogicalDisk).DeviceID

    $hashTable_bulk_drive = @{"X:" = "\\BA00FB02-sl4.DE.BOSCH.COM\Bulk01$" ; "Y:" = "\\BA00FB02-sl4.DE.BOSCH.COM\Bulk02$" }
    foreach($disk_id in $hashTable_bulk_drive.Keys)
    {
        if($disk_id -notin $list_disk_id)
        {
            net use $disk_id $hashTable_bulk_drive[$disk_id] /u:APAC\BMT8HC $password 
        }
    }

    $list_disk_id = (Get-CimInstance -ClassName Win32_LogicalDisk).DeviceID
    $list_disk_size = (Get-CimInstance -ClassName Win32_LogicalDisk).Size
    $list_disk_freespace =  (Get-CimInstance -ClassName Win32_LogicalDisk).FreeSpace
    $list_disk_volumnName = (Get-CimInstance -ClassName Win32_LogicalDisk).VolumeName
    $list_disk_provideName = (Get-CimInstance -ClassName Win32_LogicalDisk).ProviderName
    $data_json = $data | ConvertFrom-Json 
    for ($i = 0; $i -lt $list_disk_id.Count; $i++) {
        if($list_disk_id[$i] -eq "X:" -or $list_disk_id[$i] -eq "Y:")
        {
            $data_bulk = @{
            }
            $volum_name = $list_disk_volumnName[$i]
            $disk_size = [math]::round(($list_disk_size[$i] / 1Gb), 1)
            $disk_freespace = [math]::round(($list_disk_freespace[$i] /1Gb),1)
            $disk_usespace = $disk_size - $disk_freespace
            $disk_id = $list_disk_id[$i]
            $disk_provide_name = $list_disk_provideName[$i]
            $percentage_disk = [math]::round(($disk_usespace / $disk_size) * 100, 1)
            $data_bulk.Add("volumn_name", "$volum_name")
            $data_bulk.Add("volumn_ID", "$disk_id")
            $data_bulk.Add("used_space","$disk_usespace GB")
            $data_bulk.Add("capacity", "$disk_size GB" )
            $data_bulk.Add("percentage_disk", $percentage_disk)
            $data_bulk.Add("path", "$disk_provide_name")
            $data_json.data += , $data_bulk
        }
    }
    $data_json | ConvertTo-Json -Depth 100 | Out-File $path
}
. "D:\B4M\Automation\Script_Automation\get_pam_password.ps1"
$password_pam = Get-PAMPassword

$path = "D:\B4M\Automation\Script_Automation\report_4.json"
get_data_bulk_drive -path $path -password $password_pam

Copy-To-Bulk -path_report $path -path_bulk $bulk_path -password $password_pam