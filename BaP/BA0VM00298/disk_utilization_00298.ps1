$path_local= "D:\B4M\Automation\Report_File\report_3_$([System.Net.Dns]::GetHostName()).json"
$path_bulk = "\\ba00fb02-sl4.de.bosch.com\B4M\Automation\Automation_Script_Report_File"
function Copy_To_Bulk
{
    param(
        $path_local, $path_bulk
    )

    . "D:\B4M\Automation\Script_Automation\get_pam_password.ps1"
    $password_pam = Get-PAMPassword

    net use $path_bulk /u:APAC\BMT8HC $password_pam
    Copy-Item -Path $path_local -Destination $path_bulk
    net use $path_bulk /delete

}

if ((Test-Path -Path $path_local -PathType Leaf) -eq $false)
{
    # Chưa có file
    $list_disk = (Get-CimInstance -ClassName Win32_LogicalDisk).DeviceID
    $list_disk_size = (Get-CimInstance -ClassName Win32_LogicalDisk).Size
    $list_disk_freespace = (Get-CimInstance -ClassName Win32_LogicalDisk).FreeSpace
    $data_JSON = ""
    $data_disk = @()
    for($i=0; $i -lt $list_disk.Count; $i++)
    {
        if($list_disk[$i] -eq 'C:' -or $list_disk[$i] -eq 'D:')
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
    ConvertTo-Json -InputObject $data_JSON -Depth 5 | Out-File $path_local
    Copy_To_Bulk $path_local $path_bulk
}
else {
    $Json_String_Data = Get-Content $path_local | ConvertFrom-Json 
    $data_drive = $Json_String_Data.data
    $list_disk_freespace = (Get-CimInstance -ClassName Win32_LogicalDisk).FreeSpace
    
    $get_date = Get-Date -Format "HH:mm"
    Write-Host("Data Drive List: "+$data_drive.Count)
    for($i= 0; $i -lt $data_drive.Count; $i++)
    {
        $freespace_drive = [math]::round($list_disk_freespace[$i]/1Gb, 1)
        $new_data = @{
            "time" = $get_date
            "free" = $freespace_drive
        }
        $data_drive[$i].data_drive += $new_data
        Write-Host(ConvertTo-Json $data_drive[$i].data_drive -Depth 5)
        
    }
    Write-Host(ConvertTo-Json -InputObject $Json_String_Data -Depth 5)
    Remove-Item -Path $path_local
    ConvertTo-Json -InputObject $Json_String_Data -Depth 5 | Out-File $path_local

    Copy_To_Bulk $path_local $path_bulk
}

