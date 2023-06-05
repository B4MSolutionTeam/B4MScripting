
function check_file_backup($path)
{
    $backup_folder_path = $path[0]
    $log_folder_path = $path[1]
    $list_backup_file = Get-ChildItem -Path $backup_folder_path "*backup"
    if($list_backup_file.Length -eq 0)
    {
        $subject = "[ALERT XC-DC] No Backup File Found In [$([System.Net.Dns]::GetHostName()).de.bosch.com] Sytem"
        $to = "duy.tathai@vn.bosch.com"
        $from = "duy.tathai@vn.bosch.com"
        $email_content = @"
        <p style="font-size:120%;">Dear Team,</p>
        <p style="font-size:120%;">There is no backup file in the system. Please take action immediatelly !</p>
        <p style="font-size:120%; color:#ff0000;">Error Detail: </p>
        <p style="font-size:120%;">System Name: &emsp;<span style="font-size:120%;color:#ff0000;">$([System.Net.Dns]::GetHostName()).de.bosch.com</span></p>
        <p style="font-size:120%;">Path: &emsp;<span style="font-size:120%;color:#ff0000;">$backup_folder_path</span></p>
        <p style="font-size:120%;">Best Regard, </p>
        <p style="font-size:120%;">XC-DX Operation Team</p>
"@  
        send_mail($subject, $to, $from, $email_content)
    }
    else {
        $today = ((Get-Date).AddDays(-1)).ToString("yyyy-MM-dd")
        $date_last_backup_file = ((Get-Item -Path "$backup_folder_path\$([string]$list_backup_file[-1])").CreationTime).ToString("yyyy-MM-dd")
        if($date_last_backup_file -eq $today)
        {
            $subject = "[Noti XC-DX] Backup File Found In [$([System.Net.Dns]::GetHostName()).de.bosch.com] Sytem"
            $to = "duy.tathai@vn.bosch.com"
            $from = "duy.tathai@vn.bosch.com"
            $email_content = @"
            <p style="font-size:120%;">Dear Team,</p>
            <p style="font-size:120%;">Backup file found on <span style="font-size:120%;color:#00ff0f;">$(((Get-Item -Path "$backup_folder_path\$([string]$list_backup_file[-1])").CreationTime))</span> in <span style="font-size:120%;color:#00ff0f;">[$([System.Net.Dns]::GetHostName()).de.bosch.com]</span> system</p>
            <p style="font-size:120%;">Best Regard, </p>
            <p style="font-size:120%;">XC-DX Operation Team</p>
"@
            send_mail($subject, $to, $from, $email_content)
        }
        elseif ($date_last_backup_file -ne $today) {
            $log_info = check_log($log_folder_path)
            $estimate_space = $log_info[0]
            $free_space = $log_info[1]
            $subject = "[WARNING XC-DX] Not Enough Space For Storing Backup File"
            $from = "duy.tathai@.vn.bosch.com"
            $to = "duy.tathai@.vn.bosch.com"
            $email_content = @"
            <p style="font-size:120%;">Dear Team,</p>
            <p style="font-size:120%;">Backup file is not generate to store in drive because don't have enough space.</p>
            <p style="font-size:120%; color:#ff0000;">Warning Detail </p>
            <p style="font-size:100%;:">+ Server Name: &emsp; <span "font-size:120%; color:#ff0000;">$([System.Net.Dns]::GetHostName()).de.bosch.com</span></p>
            <p style="font-size:100%;:">+ Drive Capacity: &emsp; <span "font-size:120%; color:#ff0000;"></span></p>
            <p style="font-size:100%;:">+ Drive Free Space: &emsp; <span "font-size:120%; color:#ff0000;">$free_space</span></p>
            <p style="font-size:100%;:">+ Estimated Space Needed For Backup File:  &emsp; <span "font-size:120%; color:#ff0000;">$estimate_space</span></p>
            <p style="font-size:120%; color:#ff0000;">*The code will automatically run to generate backup again, please take care mailbox carefully to get notify from the tool and take action imidiately if needed !</p>
            <p style="font-size:120%;">Best Regard,</p>
            <p style="font-size:120%;">XC-DX Operation Team</p>
"@
        }

    }

}

function check_log($path_log)
{
    $today = ((Get-Date).AddDays(-1)).ToString("yyyy-MM-dd")
    $list_log_file = Get-ChildItem -Path $path_log
    $last_date_log_file = ((Get-Item -Path "$path_log\$($list_log_file[-1])").CreationTime).ToString("yyyy-MM-dd")
    $estimate_space_backup = ""
    $free_space = ""
    if($last_date_log_file -eq $today)
    {
        $log_content = Get-Content "$path_log\$($list_log_file[-1])"
        foreach($log_each_line in $log_content)
        {
            $log_each_line = [string]$log_each_line
            if($log_each_line.Contains("Estimated space needed for backup file:"))
            {
                $estimate_space_backup = ($log_each_line.Split(":"))[-1].Replace(" ","")
            }
            if($log_each_line.Contains("Directory free space:"))
            {
                $free_space = ($log_each_line.Split(":"))[-1].Replace(" ","")
            }
        }
    }
    return ($estimate_space_backup, $free_space)
    
}

function send_mail($mail_info)
{

    $emailServer = "rb-smtp-auth.rbesz01.com"
    $from = $mail_info[2]
    $to = $mail_info[1]
    $htmlBody = $mail_info[3]
    Write-Host($htmlBody)
    $Message = New-Object System.Net.Mail.MailMessage $from,$to
    $Message.IsBodyHtml = $true
    $Message.Subject = $mail_info[0]
    $Message.Body = $htmlBody
    $Smtp = New-Object Net.Mail.smtpclient($emailServer,25)
    $smtp.EnableSsl = $true
    $smtp.credentials = New-Object System.Net.NetworkCredential ("tad6hc@bosch.com", "Haha050399@@@")
    $smtp.send($Message)
}

$backup_folder_path = "C:\Users\TAD6HC\Desktop\DuyPython\Bao_Bao"
$log_folder_path = "C:\Users\TAD6HC\Desktop\DuyPython\Log_BaoBao"
check_file_backup($backup_folder_path, $log_folder_path)