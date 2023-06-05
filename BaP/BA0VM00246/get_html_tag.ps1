$ie = New-Object -com InternetExplorer.Application
$ie.visible = $true
$ie.top = 0 ; $ie.width = 3840; $ie.height = 2160; $ie.left = 0
$ie.resizable = $true
$list_server = Get-Content -Path "D:\Automation_Task\duy.txt"
foreach($server in $list_server)
{
    $url = 'https://rb-itoa-splunk-reporting.de.bosch.com/en-US/app/ITOA-Reporting/system_utilization?form.server2=*&form.Time.earliest=-24h%40h&form.Time.latest=now&form.span=15m&form.reApp=*&form.server='+$server
    $ie.navigate($url)
    #$ie.fullscreen = $true
    While ($ie.Busy) {  
        Start-Sleep 20
    }
    
    Start-Sleep 5
    $naming = ((([string]$server).Split("."))[0])
    $ie.Document.getElementById('panel1').innerHTML > "D:\Automation_Task_Report_File\CPU_$naming.html"
    $ie.Document.getElementById('panel2').innerHTML > "D:\Automation_Task_Report_File\Physical_RAM_$naming.html"
    $ie.Document.getElementById('panel3').innerHTML > "D:\Automation_Task_Report_File\Virtual_RAM_$naming.html"
    $ie.Document.getElementById('panel5').innerHTML > "D:\Automation_Task_Report_File\Disk_$naming.html"
}

$ie.quit()

$list_html = (Get-ChildItem -Path "D:\Automation_Task_Report_File" | Where-Object {$_.Extension -in ".html"})
foreach($html_file in $list_html)
{
    D:\Automation_Task\Chrome\Application\chrome.exe --headless --screenshot="D:\Automation_Task_Report_File\report_5_$((([string]$html_file).Split("."))[0]).png" --window-size=778,332 "D:\Automation_Task_Report_File\$([string]$html_file)"
}

function email_content
{

    param(
        $path_report, $path_server
    )

    $table_content = @"
"@
    $list_png = (Get-ChildItem -Path $path_report | Where-Object {$_.Extension -in ".png"}).FullName
    $list_server = Get-Content -Path $path_server
    foreach($server in $list_server)
    {
        $server_name = (([string]$server).Split("."))[0]
        $image_string = @"
"@
        foreach($png_file in $list_png)
        {
            if(([string]($png_file)).Contains($server_name))
            {
                $image_base64 = [convert]::ToBase64String((Get-Content -Path $png_file -Encoding byte))
                $image_string = $image_string + @"
                <img src="data:image/png;base64, $image_base64"/>
"@
            }
        }
        $image_cell = @"
        <td style="text-align: center;"> $image_string<td>
"@
        $each_server_contain = @"
        <tr>
            <td style="color:#000000; border: 1px solid black; width: 1920px; text-align: center;">$server</td>
            $image_cell
        </tr>
"@
        $table_content = $table_content + $each_server_contain
    }
    $email_string = @"
    <p style="font-size:115%;color:#217cb4;">Dear Team,<p>
    <p style="font-size:115%;color:#217cb4;">We would like to report chart from splunk</p>
    <table>
    <tr>
        <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Host</th>
        <th style="color:#2b32c3; border: 1px solid black; width: 1920px;">Chart</th>
    </tr>
        $table_content
    </table>
"@
    foreach($png_file in $list_png)
    {
        Remove-Item $png_file
    }
    return $email_string 
}
function send_mail_total
{
    param(
        $password, $email_content
    )
    $emailServer = "rb-smtp-auth.rbesz01.com"
    $htmlBody = $email_content
    Write-Host($htmlBody)
    $Message = New-Object System.Net.Mail.MailMessage

    $Message.From = "team.b4moperation@vn.bosch.com"
    # $Message.To.Add("duy.tathai@vn.bosch.com")
    $Message.To.Add("Hc1_CI_B4M_OperationProject@bcn.bosch.com")
    

    $Message.IsBodyHtml = $true
    $Message.Subject = "Splunk Chart Report Daily $((Get-Date).ToString("dd/MM/yyyy"))"
    $Message.Body = $htmlBody

    $Smtp = New-Object Net.Mail.smtpclient($emailServer,25)
    $smtp.EnableSsl = $true
    $smtp.credentials = New-Object System.Net.NetworkCredential ("bmt8hc@bosch.com", $password)
    $smtp.send($Message)
}
. "D:\Automation_Task\get_pam_password.ps1"
$password_pam = Get-PAMPassword
$return_value = email_content -path_report "D:\Automation_Task_Report_File" -path_server "D:\Automation_Task\duy.txt"
send_mail_total -password $password_pam -email_content $return_value

foreach($html_file in $list_html)
{
    Remove-Item -Path $html_file
}
