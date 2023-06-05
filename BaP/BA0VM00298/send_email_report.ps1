

function report_1($list_report_1)
{
    $count_error = 0
    $count_task_number = 0
    if($list_report_1.Length -gt 0)
    {
        $count_task_number = $count_task_number + 1
        $table_report_1 = @"
"@
        foreach($report_1 in $list_report_1)
        {
            $report_1_data = Get-Content -Raw -Path "$path_report\$report_1" | ConvertFrom-Json
            $status_checkout = $report_1_data.data.status.status_check_out
            $status_checkin = $report_1_data.data.status.status_check_in
            $color_checkin = ""
            $color_checkout = ""
            if($status_checkin -eq "Check In successfully")
            {
                $color_checkin = "#96D4D4"
            }
            elseif($status_checkin -eq "Check In proceed fail") {
                $color_checkin = "#ff0000"
                $count_error = $count_error + 1
            }
            elseif($status_checkin -eq "There is no backup version created")
            {
                $color_checkin = "#ff0000"
                $count_error = $count_error + 1
            }
            elseif($status_checkin -eq "Database is probaly already opened by another engine in another Window session, can't proceed this process")
            {
                $color_checkin = "#adadad"
            }
            else {
                $color_checkin = "#ff0000"
                $count_error = $count_error + 1
            }

            if($status_checkout -eq "Check Out successfully")
            {
                $color_checkout = "#96D4D4"
            }
            elseif($status_checkout -eq "Check Out fail.")
            {
                $color_checkout = "#ff0000"
                $count_error = $count_error + 1
            }
            elseif($status_checkout -eq "vDog server is in maintainance, can't proceed this process")
            {
                $color_checkout = "#adadad"
                $count_error = $count_error + 1
            }
            else {
                $color_checkout = "#ff0000"
                $count_error = $count_error + 1
            }

            $server_name = $report_1_data.data.server
            $table_report_1 = $table_report_1 + @"
            <tr>
                <th style="background-color:$color_checkin; border: 1px solid black; width: 1920px;">$server_name.de.bosch.com</th>
                <th style="background-color:$color_checkin; border: 1px solid black; width: 1920px;">Check In</th>
                <th style="background-color:$color_checkin; border: 1px solid black; width: 1920px;">$status_checkin</th>
            </tr>
            <tr>
                <th style="background-color:$color_checkout; border: 1px solid black; width: 1920px;">$server_name.de.bosch.com</th>
                <th style="background-color:$color_checkout; border: 1px solid black; width: 1920px;">Check Out</th>
                <th style="background-color:$color_checkout; border: 1px solid black; width: 1920px;">$status_checkout</th>
            </tr>
"@
            
        }
        $content_section_1 = @"
        <p style="font-size:115%">$count_task_number - Routine Test Check In/Out Report </p>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">
            <tr>
                <th style="color:#2b32c3;"><h3>Routine Test Check In/Out Report<h3></tr>
            </tr>
        </table>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">
            <tr>
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Host</th>
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Service</th>
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Status</th>
            </tr>
            $table_report_1
        </table>
"@
    }
    
    return @($count_error, $content_section_1, $count_task_number)
}

function report_2($information_section_1)
{
    $total_error = $information_section_1[0]
    $content_section = $information_section_1[1]
    $task_number = $information_section_1[2]
    $list_report_2 = $information_section_1[3]
    # Write-Host($total_error)
    # Write-Host($content_section_2)
    # Write-Host($list_report_2)
    # Write-Host($task_number)
    $content_section_2 = @"
    
"@
    if($list_report_2.Length -gt 0)
    {
        $task_number = $task_number + 1
        $table_report_2 = @"
"@
        $message_status = ""    
        foreach($report_2 in $list_report_2)
        {
            $data_report_2 = Get-Content -Raw -Path "$path_report\$report_2" | ConvertFrom-Json
            $server_name = $data_report_2.data.server
            $service_name = $data_report_2.data.service.service_name
            $service_status = $data_report_2.data.service.service_status
            
            $color_status = "#96D4D4"
            if($service_status -eq "Running")
            {
                $color_status = "#96D4D4"
            }
            else
            {
                $message_status = @"
                <p style="font-size:115%; color:#ff0000;">*The service automatically restart, please review and take action if the service is not start again </p>
"@
                $total_error = $total_error + 1
                $color_status = "#ff0000"
            }
            $table_report_2 = $table_report_2 + @"
            <tr>
                <th style="background-color:$color_status; border: 1px solid black; width: 1920px;">$server_name.de.bosch.com</th>
                <th style="background-color:$color_status; border: 1px solid black; width: 1920px;">$service_name</th>
                <th style="background-color:$color_status; border: 1px solid black; width: 1920px;">$service_status</th>
            </tr>
"@
        $content_section_2 = $content_section + @"
        <p style="font-size:115%">$task_number - vDog Checking/Recover Service Status </p>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">
            <tr>
                <th style="color:#2b32c3;"><h3>vDog Checking/Recover Service Status<h3></tr>
            </tr>
        </table>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">
        <tr>
            <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Host</th>
            <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Service</th>
            <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Status</th>
        </tr>
        $table_report_2

        </table>
        $message_status
"@
        }
        
    }
    else
    {
        $content_section_2 = $content_section_2 + $content_section
    }
    return @($total_error, $content_section_2, $task_number)
}

function report_3($information_section_2)
{
    $count_error = $information_section_2[0]
    $content_section = $information_section_2[1]
    $task_number = $information_section_2[2]
    $list_report_3 = $information_section_2[3]

    $content_section_3 = @"
"@
    $list_drive_total = @()
    if($list_report_3 -gt 0)
    {
        $task_number = $task_number + 1
        $head_content = @"
        <th style="color:#2b32c3; border: 1px solid black; width: 1920px;"></th>
"@
        foreach($report_3 in $list_report_3)
        {
            $data_report_3 = Get-Content -Raw -Path "$path_report\$report_3" | ConvertFrom-Json 
            foreach($information_drive in $data_report_3.data)
            {
                if($list_drive_total -notcontains $information_drive.drive)
                {
                    $list_drive_total += $information_drive.drive
                    $head_content = $head_content + @"

                    <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">$($information_drive.drive)</th>
"@
                }
            }
        }
        $header_table = @"
        <tr>
            $head_content
        </tr>
"@
        $row_server_content = @"
"@

        foreach($report_3 in $list_report_3)
        {

            $data_report_3 = Get-Content -Raw -Path "$path_report\$report_3" | ConvertFrom-Json
            Write-Host($data_report_3.server_name)
            $list_disk_server = @()
            $row_content = @"
            <th style="background-color:#96D4D4; border: 1px solid black; width: 1920px;">$($data_report_3.server_name)</th>
"@
            foreach($data_server in $data_report_3.data)
            {
                $list_disk_server += $data_server.drive
            }
            foreach($drive in $list_drive_total)
            {
                if($drive -in $list_disk_server)
                {
                    $index_disk = [array]::IndexOf($list_disk_server, $drive)
                    $freespace = (((($data_report_3.data)[$index_disk]).data_drive)[-1]).free
                    $drive_size = (($data_report_3.data)[$index_disk]).size
                    $percentage = [math]::Round((($drive_size - $freespace)/$drive_size) * 100)
                    $color_status = "#96D4D4"
                    if($percentage -gt 90)
                    {
                        $color_status = "#ff0000"
                        $count_error = $count_error + 1
                    }
                    
                    $row_content = $row_content +  @"

                    <th style="background-color:$color_status; border: 1px solid black; width: 1920px;">$percentage % ($(($drive_size - $freespace)) GB/ $drive_size GB) </th>
"@
                }
                else {
                    $row_content = $row_content +  @"

                    <th style="background-color:#96D4D4; border: 1px solid black; width: 1920px;"></th>
"@
                }
            }
            $row_server_content = $row_server_content + @"
            
            <tr>

                $row_content
            </tr>
"@
        }
        $content_section_3 = $content_section + @"
        <p style="font-size:115%">$task_number - Used Space's Disk Status Check </p>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">
            <tr>
                <th style="color:#2b32c3;"><h3>Used Space's Disk Status Check<h3></tr>
            </tr>
        </table>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">     
        $header_table
        $row_server_content
        </table>
"@
    }
    else
    {
        $content_section_3 = $content_section_3 + $content_section
    }
    return @($count_error, $content_section_3, $task_number)

}

function report_4($information_section_3)
{
    $count_error = $information_section_3[0]
    $content_section = $information_section_3[1]
    $task_number = $information_section_3[2]
    $list_report_4 = $information_section_3[3]

    # Write-Host($count_error)
    # Write-Host($content_section)
    # Write-Host($task_number)
    # Write-Host($list_report_4)
    $content_section_4 = @"
"@
    if($list_report_4.Length -gt 0)
    {
        $task_number = $task_number + 1
        $table_report_4 = ""
        foreach($report_4 in $list_report_4)
        {
            $data_report_4 = Get-Content -Raw -Path "$path_report\$report_4" | ConvertFrom-Json
            $table_report_4 = @"
"@
            foreach($bulk_drive in $data_report_4.data)
            {
                $bulk_drive_capacity = $bulk_drive.capacity
                $bulk_drive_used_space = $bulk_drive.used_space
                $bulk_drive_percentage = $bulk_drive.percentage_disk
                $bulk_drive_name = $bulk_drive.volumn_name
                $bulk_drive_path = $bulk_drive.path
                $color_status = ""
                if($bulk_drive_percentage -gt 90)
                {
                    $color_status = "#ff0000"
                    $count_error = $count_error + 1
                }
                else {
                    $color_status = "#96D4D4"
                }
                $table_report_4 = $table_report_4 + @"
                <tr>
                    <th style="background-color:$color_status; border: 1px solid black; width: 1920px;">$bulk_drive_name</th>
                    <th style="background-color:$color_status; border: 1px solid black; width: 1920px;">$bulk_drive_path</th>
                    <th style="background-color:$color_status; border: 1px solid black; width: 1920px;">$bulk_drive_percentage % ($bulk_drive_used_space / $bulk_drive_capacity)</th>
                </tr>
"@
            }

        }
        $content_section_4 = $content_section + @"
        <p style="font-size:115%">$task_number - Used Space's Bulk Drive Checking Service </p>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">
            <tr>
                <th style="color:#2b32c3;"><h3>Used Space's Bulk Drive Checking Service<h3></tr>
            </tr>
        </table>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">
            <tr>
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Drive Name</th>
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Drive Path</th>
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Use / Total</th>
            </tr>
            $table_report_4
        </table>
"@
    }
    else {
        $content_section_4 = $content_section_4 + $content_section
    }
    return @($count_error, $content_section_4, $task_number)

}

function report_5($information_section_4)
{
    $count_error = $information_section_4[0]
    $content_section = $information_section_4[1]
    $task_number = $information_section_4[2]
    $list_report_5 = $information_section_4[3]

    # Write-Host($count_error)
    # Write-Host($content_section)
    # Write-Host($task_number)
    # Write-Host($list_report_5)
    $content_section_5 = @"
"@
    $image_base64 = @"
"@
    if($list_report_5.Length -gt 0)
    {
        $task_number = $task_number + 1
        foreach($report_5 in $list_report_5)
        {
            $image_path = "$path_report\$report_5"
            $base64_string = [convert]::ToBase64String((Get-Content -Path $image_path -Encoding byte))
            $image_base64 = $image_base64 + @"
            <img width="968" height="302" src="data:image/png;base64,$base64_string" />
"@

        }
        $content_section_5 = $content_section + @"
        <p style="font-size:115%">4 - System Utilization Chart </p>
        $image_base64
"@
    }
    else {
        $content_section_5 = $content_section_5 + $content_section 
    }
    return @($count_error, $content_section_5, $task_number)
}
function send_mail_total
{
    param(
        $total_error, $email_content, $password
    )
    $emailServer = "rb-smtp-auth.rbesz01.com"
    $htmlBody = $email_content
    Write-Host($htmlBody)
    $Message = New-Object System.Net.Mail.MailMessage

    $Message.From = "team.b4moperation@vn.bosch.com"
    # $Message.To.Add("duy.tathai@vn.bosch.com")
    $Message.To.Add("Hc1_CI_B4M_OperationProject@bcn.bosch.com")
    

    $Message.IsBodyHtml = $true
    $Message.Subject = "[$total_error WARNING] vDog Service Report $((Get-Date).ToString("dd/MM/yyyy"))"
    $Message.Body = $htmlBody

    $Smtp = New-Object Net.Mail.smtpclient($emailServer,25)
    $smtp.EnableSsl = $true
    $smtp.credentials = New-Object System.Net.NetworkCredential ("bmt8hc@bosch.com", $password)
    $smtp.send($Message)
}

######################################################################################################################

$path_report = "D:\B4M\Automation\Report_File"

. "D:\B4M\Automation\Script_Automation\get_pam_password.ps1"
$password_pam = Get-PAMPassword

$bulk_path = "\\ba00fb02-sl4.de.bosch.com\B4M\Automation\Automation_Script_Report_File"
net use $bulk_path /u:APAC\BMT8HC $password_pam
Copy-Item -Path "$bulk_path\*" -Destination $path_report

Start-Sleep 5

$list_report_file = Get-ChildItem -Path $path_report| Where-Object { $_.Extension -in '.png', '.json'}
$list_report_1 = @()
$list_report_2 = @()
$list_report_3 = @()
$list_report_4 = @()
$list_report_5 = @()

foreach($report_file in $list_report_file)
{
    $report_file = [string]$report_file
    if($report_file.Contains("report_1_"))
    {
        $list_report_1 += $report_file
    }
    elseif ($report_file.Contains("report_2_")) {
        $list_report_2 += $report_file
    }
    elseif ($report_file.Contains("report_3_")) {
        $list_report_3 += $report_file
    }
    elseif ($report_file.Contains("report_4"))
    {
        $list_report_4 += $report_file
    }
    elseif ($report_file.Contains("report_5_")) 
    {
        $list_report_5 += $report_file
    }
}


$email_content = @"
<p style="font-size:115%;color:#217cb4;">Dear Team,<p>
<p style="font-size:115%;color:#217cb4;">We would like to report from BA0VM00298.de.bosch.com, BA0VM00303.de.bosch.com, BA0VM00304.de.bosch.com</p>
"@

$result_report_1 = report_1($list_report_1)
$total_error_section_1 = $result_report_1[0]
$email_content = $email_content + $result_report_1[1]
$task_number = $result_report_1[2]

$result_report_2 = report_2($total_error_section_1, $email_content, $task_number, $list_report_2)
$total_error_section_2 = $result_report_2[0]
$email_content_section_2 = $result_report_2[1]
$task_number = $result_report_2[2]

$result_report_3 = report_3($total_error_section_2, $email_content_section_2, $task_number, $list_report_3)
$total_error_section_3 = $result_report_3[0]
$email_content_section_3 = $result_report_3[1]
$task_number = $result_report_3[2]

$result_report_4 = report_4($total_error_section_3, $email_content_section_3, $task_number, $list_report_4)
$total_error_section_4 = $result_report_4[0]
$email_content_section_4 = $result_report_4[1]
$task_number = $result_report_4[2]


$result_report_5 = report_5($total_error_section_4, $email_content_section_4, $task_number, $list_report_5)
$total_error_section_5 = $result_report_5[0]
$email_content_section_5 = $result_report_5[1]
$task_number = $result_report_5[2]

$email_content_section_5 = $email_content_section_5 + @"
<p style="font-size:115%;color:#217cb4;">Best Regard,</p>
<p style="font-size:115%;color:#217cb4;">B4M Operation Team</p>
"@

send_mail_total -total_error $total_error_section_5 -email_content $email_content_section_5 -password $password_pam
foreach($report_file in $list_report_file)
{
    Remove-Item -Path "$path_report\$report_file"
}
# Remove-Item -Path "$bulk_path\*"
net use $bulk_path /delete

