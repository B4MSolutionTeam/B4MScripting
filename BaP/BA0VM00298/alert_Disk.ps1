
function Get_Data_Disk
{
    param(
        $password
    )
    # New-PSDrive -Name "Y" -PSProvider FileSystem -Root "\\BA00FB02.DE.BOSCH.COM\Bulk02$" -Persist
    # New-PSDrive -Name "Z" -PSProvider FileSystem -Root "\\BA00FB02.DE.BOSCH.COM\Bulk01$" -Persist
    
    $list_disk = (Get-CimInstance -ClassName Win32_LogicalDisk).DeviceID
    $list_disk_size = (Get-CimInstance -ClassName Win32_LogicalDisk).Size
    $list_disk_freespace =  (Get-CimInstance -ClassName Win32_LogicalDisk).FreeSpace
    $list_disk_providerName = (Get-CimInstance -ClassName Win32_LogicalDisk).ProviderName
    

    
    Write-Host($list_disk)
    if("Y:" -in $list_disk -and "X:" -in $list_disk)
    {
        Write-Host("Drive detect")
        $total_list_disk_data = @()
        for ($i = 0; $i -lt $list_disk.Count; $i++) {
            if($list_disk[$i] -eq "Y:" -or $list_disk[$i] -eq "X:")
            {
                $bulk_path = $list_disk_providerName[$i]
                $provider_name = ($list_disk_providerName[$i].Split("\"))[-1]
                $size = [math]::round($list_disk_size[$i] /1Gb, 3)
                $free_space = [math]::round($list_disk_freespace[$i] /1Gb, 3)
                $use_space = $size - $free_space
                $list_disk_data = $provider_name, $size, $free_space, $use_space, $bulk_path
                $total_list_disk_data += , $list_disk_data
            }
        }
        return $total_list_disk_data
    }
    elseif ("Y:" -notin $list_disk -or "X:" -notin $list_disk) 
    {
        net use Y: \\BA00FB02-sl4.DE.BOSCH.COM\Bulk02$ /u:APAC\BMT8HC $password
        net use X: \\BA00FB02-sl4.DE.BOSCH.COM\Bulk01$ /u:APAC\BMT8HC $password
        Start-Sleep 5
        Write-Host("Drive not detect")        
        $list_disk = (Get-CimInstance -ClassName Win32_LogicalDisk).DeviceID
        $list_disk_size = (Get-CimInstance -ClassName Win32_LogicalDisk).Size
        $list_disk_freespace =  (Get-CimInstance -ClassName Win32_LogicalDisk).FreeSpace
        $list_disk_providerName = (Get-CimInstance -ClassName Win32_LogicalDisk).ProviderName
        
        $total_list_disk_data = @()
        for ($i = 0; $i -lt $list_disk.Count; $i++) {
            if($list_disk[$i] -eq "Y:" -or $list_disk[$i] -eq "X:")
            {
                $bulk_path = $list_disk_providerName[$i]
                $provider_name = ($list_disk_providerName[$i].Split("\"))[-1]
                $size = [math]::round($list_disk_size[$i] /1Gb, 3)
                $free_space = [math]::round($list_disk_freespace[$i] /1Gb, 3)
                $use_space = $size - $free_space
                $list_disk_data = $provider_name, $size, $free_space, $use_space, $bulk_path
                $total_list_disk_data += , $list_disk_data
            }
        }
        return $total_list_disk_data
    }
}

function generate_email_content_test
{
    param(
        $path_json, $password
    )
    $disk_info_json = Get-Content -Raw $path_json | ConvertFrom-Json
    $detail_alert = @"
"@
    $table_content_detail = @"
"@
    for ($i = 0; $i -lt ($disk_info_json.data).Count; $i++) {
        
        if(($disk_info_json.data[$i].disk_info_alert).Length -eq 5)
        {
            $drive_name = $disk_info_json.data[$i].provider_name
            $drive_path = $disk_info_json.data[$i].drive_path
            $timestamp = ($disk_info_json.data[$i].disk_info_alert[-1]).timestamp
            $free_space_disk = ($disk_info_json.data[$i].disk_info_alert[-1]).disk_free
            $used_space_disk = ($disk_info_json.data[$i].disk_info_alert[-1]).disk_used
            $size_disk = ($disk_info_json.data[$i].disk_info_alert[-1]).disk_size
            $table_content_detail = $table_content_detail + @"
            <tr>
                <th style="border: 1px solid black; color:#FF0000; width: 1920px; font-size: 130%;">$drive_name</th>
                <th style="border: 1px solid black; color:#FF0000; width: 1920px; font-size: 130%;">$drive_path</th>
                <th style="border: 1px solid black; color:#FF0000; width: 1920px; font-size: 130%;">$timestamp</th>
                <th style="border: 1px solid black; color:#FF0000; width: 1920px; font-size: 130%;">$([math]::round(($used_space_disk/$size_disk)*100 ,1)) % ($used_space_disk GB / $size_disk GB)</th>
            </tr>
"@
        }
    }
    
    for ($i = 0; $i -lt ($disk_info_json.data).Count; $i++) {
        if(($disk_info_json.data[$i].disk_info_alert).Length -eq 5)
        {
            
            $drive_name = $disk_info_json.data[$i].provider_name
            $drive_path = $disk_info_json.data[$i].drive_path
            $list_infor_each_drive = $disk_info_json.data[$i].disk_info_alert
            $timestamp_list = @()
            $percent_list = @()
            for ($j = 0; $j -lt ($list_infor_each_drive).Count; $j++) {
                $timestamp_list += $list_infor_each_drive[$j].timestamp 
                $percentage = [math]::round(($used_space_disk/$size_disk)*100 ,3)
                $percent_list += "$percentage %"
            }
            $detail_alert = $detail_alert + @"
        <p style="font-size: 140%; color:#FF0000;">2.$($i +1). Alert detail of $drive_name Drive: </p>
        <p style="font-size: 120%;">- Drive Name: &emsp; $drive_name</p>
        <p style="font-size: 120%;">- Drive Path: &emsp; $drive_path</p>
        <p style="font-size: 120%;">- State Change: &emsp; OK -> ALERT</p>
        <p style="font-size: 120%;">- Reason for State Change: &emsp; Threshold Crossed: 4 out of the last 5 datapoints [ $($percent_list[0]) ($($timestamp_list[0])), $($percent_list[1]) ($($timestamp_list[1])), $($percent_list[2]) ($($timestamp_list[2]), $($percent_list[3]) ($($timestamp_list[3]))) ] were greater than or equal to the threshold (90.0) (minimum 4 datapoints for OK -> ALARM transition).</p>
        <p style="font-size: 120%;">- Last Timestamp: &emsp;    $($timestamp_list[-1]) </p>
"@
        }
        
    }
    
    
    Remove-Item -Path $path_json
    $disk_info_json | ConvertTo-Json -Depth 100 | Out-File  $path_json
    
    $email_content = @"
    <p style="font-size:150%;color:#217cb4;">Dear Team,</p>
    <p style="font-size:150%;color:#217cb4;">Bulk Drive Size Alert! Bulk use space has touched the threshold (greater than or equal to 90%). Please take action immediatelly !</p>    
    <p style="font-size:150%;color:#217cb4;">1. List of Bulk Drive Alert </p>
    <table style="background-color:#96D4D4 ;">
    <tr>
        <th style="border: 1px solid black; width: 1920px; font-size: 130%;">Drive Name</th>
        <th style="border: 1px solid black; width: 1920px; font-size: 130%;">Drive Path</th>
        <th style="border: 1px solid black; width: 1920px; font-size: 130%;">Last Timestamp</th>
        <th style="border: 1px solid black; width: 1920px; font-size: 130%;">% Use/Total</th>
    </tr>
    $table_content_detail
    </table>
    <p style="font-size:150%;color:#217cb4;">2. Alert Detail </p>
    $detail_alert
    <p style="font-size:150%;color:#217cb4;">Best Regard,</p>
    <p style="font-size:150%;color:#217cb4;">B4M Operation Team</p>    
"@
    send_mail_alert -email_content $email_content -password $password
    for ($i = 0; $i -lt ($disk_info_json.data).Count; $i++) {
        if(($disk_info_json.data[$i].disk_info_alert).Length -eq 5)
        {
            $disk_info_json.data[$i].disk_info_alert = @()
        }
    }
    Remove-Item -Path $path_json
    $disk_info_json | ConvertTo-Json -Depth 100 | Out-File  $path_json
    
}
function extract_data
{
    param(
        $path_json, $password
    )
    $disk_data = Get_Data_Disk -password $password
    $list_disk_info_alert = @()
    $count_alert_disk = 0
    $disk_info_json = Get-Content -Raw $path_json | ConvertFrom-Json
    for ($i = 0; $i -lt $disk_data.Count; $i++) {
        $provider_name_disk = $disk_data[$i][0]
        $size_disk = $disk_data[$i][1]
        $free_space_disk = $disk_data[$i][2]
        $use_space_disk = $disk_data[$i][3]
        $bulk_path_disk = $disk_data[$i][4]
        $disk_percentage = ($use_space_disk/ $size_disk) * 100
        if($disk_percentage -gt 90)
        {
            for ($j = 0; $j -lt ($disk_info_json.data).Count; $j++) {
                if($disk_info_json.data[$j].provider_name -eq $provider_name_disk)
                {
                    if(($disk_info_json.data[$j].disk_info_alert).Length -lt 4)
                    {
                        $disk_info_alert = [PSCustomObject]@{timestamp=Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss"; disk_free=$free_space_disk; disk_used=$use_space_disk; disk_size=$size_disk;}
                        $disk_info_json.data[$j].disk_info_alert += $disk_info_alert
                    }
                    elseif(($disk_info_json.data[$j].disk_info_alert).Length -eq 4)
                    {
                        $disk_info_alert = [PSCustomObject]@{timestamp=Get-Date -Format "dddd MM/dd/yyyy HH:mm:ss"; disk_free=$free_space_disk; disk_used=$use_space_disk; disk_size=$size_disk;}
                        $disk_info_json.data[$j].disk_info_alert += $disk_info_alert
                        $count_alert_disk = $count_alert_disk + 1
                    }
                    # if(($disk_info_json.data[$j].disk_info_alert).Length -eq 5)
                    # {
                    #     $count_alert_disk = $count_alert_disk + 1   
                    # }
                }
                
            }
        }
        else
        {
            for ($j = 0; $j -lt ($disk_info_json.data).Count; $j++) {
                if($disk_info_json.data[$j].provider_name -eq $provider_name_disk)
                {
                    $disk_info_json.data[$j].disk_info_alert = @()
                }
                
            }
        }
    }
    Remove-Item -Path $path_json
    $disk_info_json | ConvertTo-Json -Depth 100 | Out-File  $path_json
    
    if($count_alert_disk -gt 0)
    {7
        generate_email_content_test -path_json $path_json -password $password
    }
   
    
    
    
}
function send_mail_alert
{
    param(
        $email_content, $password
    )
    
    $emailServer = "rb-smtp-auth.rbesz01.com"
    $htmlBody = $email_content
    Write-Host($htmlBody)
    $Message = New-Object System.Net.Mail.MailMessage

    $Message.From = "team.b4moperation@vn.bosch.com"
    $Message.To.Add("Hc1_CI_B4M_OperationProject@bcn.bosch.com")
    

    $Message.IsBodyHtml = $true
    $Message.Subject = "[WARNING] Alert For Bulk Drive Touching Threshold"
    $Message.Body = $htmlBody

    $Smtp = New-Object Net.Mail.smtpclient($emailServer,25)
    $smtp.EnableSsl = $true
    $smtp.credentials = New-Object System.Net.NetworkCredential ("bmt8hc@bosch.com", $password)
    $smtp.send($Message)
}
#D:\Automation_Task\disk_info_bulk.json
#C:\hello\disk_info_bulk.json
$path_json = "D:\B4M\Automation\Script_Automation\disk_info_bulk.json"
. "D:\B4M\Automation\Script_Automation\get_pam_password.ps1"
$password_pam = Get-PAMPassword

extract_data -path_json $path_json -password $password_pam
Start-Sleep -Seconds 60    

# extract_data