function send_mail
{
    param(
        $password, $email_content
    )
    $emailServer = "rb-smtp-auth.rbesz01.com"
    $htmlBody = $email_content
    Write-Host($htmlBody)
    $Message = New-Object System.Net.Mail.MailMessage

    $Message.From = "team.b4moperation@vn.bosch.com"
    $Message.To.Add("duy.tathai@vn.bosch.com")
    # $Message.To.Add("Hc1_CI_B4M_OperationProject@bcn.bosch.com")
    

    $Message.IsBodyHtml = $true
    $Message.Subject = "[WARNING] PAM-Vault Certificate will reach expire date"
    $Message.Body = $htmlBody

    $Smtp = New-Object Net.Mail.smtpclient($emailServer,25)
    $smtp.EnableSsl = $true
    $smtp.credentials = New-Object System.Net.NetworkCredential ("bmt8hc@bosch.com", $password)
    $smtp.send($Message)
}

function Get_List_Thumbprint
{
    
    param(
        $bulk_drive, $password
    )

    net use $bulk_drive /u:APAC\BMT8HC $password
    
    $list_Thumbprint = Import-Csv -Path "$bulk_drive\Thumbprint_Server.csv"
    $list_Thumbprint_return = @()
    foreach($thumbprint in $list_Thumbprint)
    {
        if($thumbprint.ServerName -eq $([System.Net.Dns]::GetHostByName($env:computerName).HostName))
        {
            $list_Thumbprint_return += $thumbprint.Thumbprint
        }
    }
    net use $bulk_drive /delete
    return $list_Thumbprint_return
}
function Check_Certificate
{
    param(
        $list_thumbprint, $password
    )
    $each_row = @"
"@
    $count_fail = 0 
    foreach($thumbprint in $list_thumbprint)
    {
        $certificate_properties = Get-ChildItem -Path "Cert:\LocalMachine\My\$thumbprint" | Select-Object Subject,NotAfter
        $result = New-TimeSpan -Start (Get-Date).Date -End $certificate_properties.NotAfter
        
        if($result.Days -lt 45)
        {
            
            $each_row = $each_row + @"
            <tr>
                <th style="background-color:#ff0000; border: 1px solid black; width: 1920px;">$($certificate_properties.Subject)</th>
                <th style="background-color:#ff0000; border: 1px solid black; width: 1920px;">$(($certificate_properties.NotAfter).ToString("dd/MM/yyyy"))</th>        
                <th style="background-color:#ff0000; border: 1px solid black; width: 1920px;">$([System.Net.Dns]::GetHostName())</th>        

            </tr>
"@
            $count_fail = $count_fail + 1
        }
    }
   
    if($count_fail -gt 0)
    {
        $email_string = @"
        <p style="font-size:115%;color:#217cb4;">Dear Team,<p>
        <p style="font-size:115%;color:#217cb4;">Some PAM_Vault Thumbprint is about reaching expire date. Please take action to avoid from the error </p>
        <table style="border: 1px solid black; width: 1920px; font-size: 110%; background-color: #96D4D4;">
            <tr>   
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Certificate Name</th>
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Expire Date</th>
                <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Machine</th>
        
            </tr>
            $each_row
        </table>
        <p style="font-size:115%;color:#217cb4;">Best Regard,</p
        <p style="font-size:115%;color:#217cb4;">B4M Operation Team</p>
"@
        send_mail -password $password -email_content $email_string
    }

}

. "D:\B4M\Automation\Script_Automation\get_pam_password.ps1"
$password_pam = Get-PAMPassword
$bulk_drive = "\\ba00fb02.de.bosch.com\B4M\Automation\Automation_Script"
$list_thumbprint_return = Get_List_Thumbprint -bulk_drive $bulk_drive -password $password_pam
Check_Certificate -list_thumbprint $list_thumbprint_return -password $password_pam
