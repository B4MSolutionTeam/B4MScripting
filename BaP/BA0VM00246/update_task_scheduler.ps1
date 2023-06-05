. "D:\Automation_Task\get_pam_password.ps1"
$password_pam = Get-PAMPassword

schtasks /change /tn "Automation Task\Chart Splunk Report Daily" /ru APAC\BMT8HC /rp $password_pam