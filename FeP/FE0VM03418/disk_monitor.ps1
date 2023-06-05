$path = "D:\Automation_Task_Report_File\report_3_$([System.Net.Dns]::GetHostName()).json"
$bulk_path = "\\ba00fb02.de.bosch.com\B4M\Report"
function Copy_To_Bulk
{
    param(
        $path_report, $path_bulk
    )
    . ""
    net use $path_bulk /u:APAC\BMT8HC $password
}
if ((Test-Path -Path $path -PathType Leaf) -eq $false)
{
    # Chưa có file
    $list_disk = (Get-CimInstance -ClassName Win32_LogicalDisk).DeviceID
    $list_disk_size = (Get-CimInstance -ClassName Win32_LogicalDisk).Size
    $list_disk_freespace = (Get-CimInstance -ClassName Win32_LogicalDisk).FreeSpace
    $data_JSON = ""
    $data_disk = @()
    for($i=0; $i -lt $list_disk.Count; $i++)
    {
        if($list_disk[$i] -eq 'C:' -or $list_disk[$i] -eq 'D:' -or $list_disk[$i] -eq 'V:')
        {
            $server_name = [System.Net.Dns]::GetHostByName($env:computerName).HostName
            $drive_name = $list_disk[$i]
            $size_drive = [math]::round($list_disk_size[$i]/1Gb, 1)
            $freespace_drive = [math]::round($list_disk_freespace[$i]/1Gb, 1)
            $get_date = Get-Date -Format "HH:mm"
            $data_disk_element = @{
                "drive"= $drive_name
                "size"= $size_drive
                "data_drive"= @(
                    @{
                        "time"= $get_date
                        "free"= $freespace_drive
                    }
                )
            }
            $data_disk += $data_disk_element
        }
    }
   
    $data_JSON = @{
        'server_name'= $server_name
        'data'= @(
            $data_disk
        )
    }
    Write-Host(ConvertTo-Json -InputObject $data_JSON -Depth 5)
    ConvertTo-Json -InputObject $data_JSON -Depth 5 | Out-File $path
    net use $path /u:APAC\BMT8HC 
    Copy-Item -Path $path -Destination $bulk_path
    
}
else {
    $Json_String_Data = Get-Content -Raw -Path $path | ConvertFrom-Json 
    $data_drive = $Json_String_Data.data
    $list_disk =  (Get-CimInstance -ClassName Win32_LogicalDisk).DeviceID
    $list_disk_freespace = (Get-CimInstance -ClassName Win32_LogicalDisk).FreeSpace
    foreach($each_drive in $data_drive)
    {
        if($each_drive.drive -in $list_disk)
        {
            $index_list = [array]::IndexOf($list_disk, $each_drive.drive)
            $freespace_disk = $list_disk_freespace[$index_list]
            $get_date = Get-Date -Format "HH:mm"
            $new_data = @{
                "time" = $get_date
                "free" = [math]::round($freespace_disk/1Gb, 1)
            }
            $each_drive.data_drive += $new_data
        }
        
    }
    ConvertTo-Json -InputObject $Json_String_Data -Depth 5 | Out-File $path
    
}

