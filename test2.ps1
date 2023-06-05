$User = "apac\bmt8hc"
$PWord = ConvertTo-SecureString -String "h0B5uL851Vz3" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord

# $pat = "e3x5b6ler2dksl44o7dgquhnh5s2k6nqomltnbdjuhligflpyy6a"
# $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($pat)"))
# $header = @{
#     authorization = "Basic $token"
# }
# $url = "https://dev.azure.com/B4MService/Software%20Upgrading/_apis/testplan/plans/1/Suites/100/TestPoint?api-version=7.0"

# $body = @"
# [{
#     "id": 188,
#     "results": {
#     "outcome": "failed"
#     }
# }]
# "@
# $request_return=Invoke-RestMethod -Method Patch -Uri $url -Proxy "http://rb-proxy-sl.bosch.com:8080" -Headers $header -Body $body -ContentType "application/json"
# write-host($request_return.value)

# $User = "apac\bmt8hc"
# $PWord = ConvertTo-SecureString -String "B4m013209112022@" -AsPlainText -Force
# $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord


# function Get-PAMPassword 
# {   
#     $userID = "APAC\BMT8HC"
#     $uid = $($userID -replace ".*\\").Trim()
#     $certThumbprint = "6843BB67DF117B8BA88C05A2DD6854B92CCBB027"                      #Replace the certificate thumbprint
#     $certPath = "Cert:\LocalMachine\My\" + $certThumbprint
#     $myCert = Get-ChildItem -Path $certPath
#     $appID = "CCP_ITM_ba"                                                           #Replace with AppID
#     $safe = "PS_B4M_App"                                                   #Replace with vault name
#     $url = "https://rb-pam-aim.bosch.com/AIMCertAuth/api/Accounts?AppID=$appID&Safe=$safe&UserName=$uid"
#     $password = Invoke-RestMethod -Uri $url -Method GET -ContentType "application/json" -Certificate $myCert
#     $password.Content.Trim()
#     Write-Host $password
# }

# Invoke-Command -ComputerName "BA0VM153.de.bosch.com" -ScriptBlock ${Function:Get-PAMPassword} -Credential $Credential
# Invoke-Command -ComputerName "BA0VM153.de.bosch.com" -ScriptBlock {Get-ChildItem -Path "Cert:\LocalMachine\My\" } -Credential $Credential

# Get-Process | Where-Object {$_.Modules.FileName -eq "D:\Test\Adminlog.ini"}

# $a = "dsadads asdasd"
# $b = $a.Split()

# for ($i = 0; $i -lt $ini_content.Count; $i++) {
#     Write-Host("$i $($ini_content[$i])")
# }
# Invoke-RestMethod -URI 'https://rb-pam-api.bosch.com/PasswordVault/API/auth/ldap/Logon' -Method Post -ContentType "application/json" -Body ""




# $NT_USER = "tad6hc"
# $NT_PASSWORD = "Haha050399@@@"
# $PAM_SERVERNAME = "rb-pam-api.bosch.com"

# $payload = @{
#     username = $NT_USER
#     password = $NT_PASSWORD
# } | ConvertTo-Json
# Write-Host($payload)

# $uri = "https://${PAM_SERVERNAME}/PasswordVault/API/auth/ldap/Logon"
# $response = Invoke-RestMethod -Uri $uri -Method Post -ContentType "application/json" -Body $payload

# $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $NT_USER,$NT_PASSWORD)))
# $headers = @{Authorization=("Basic {0}" -f $base64AuthInfo)}

# Invoke-RestMethod -Uri "https://${PAM_SERVERNAME}/PasswordVault/API/auth/ldap/Logon/Safe?query=ITM_applications_ba" -Method Get -Headers @{"Content-Type" = "application/json"; "Authorization" = "${response}"}

# New-PSDrive -Name W -PSProvider FileSystem -Root "\\BA0VM060.de.bosch.com\Automation_Script_Report_File\" -Credential $Credential

# function send_mail
# {
#     param(
#         $email_content, $subject
#     )
#     $emailServer = "rb-smtp-auth.rbesz01.com"
#     $htmlBody = $email_content
#     Write-Host($htmlBody)
#     $Message = New-Object System.Net.Mail.MailMessage

#     $Message.From = "vinh.phamtruong@vn.bosch.com"
#     $Message.To.Add("vinh.phamtruong@vn.bosch.com")
#     #$Message.To.Add("")

#     $Message.IsBodyHtml = $true
#     $Message.Subject = $subject
#     $Message.Body = $htmlBody

#     $Smtp = New-Object Net.Mail.smtpclient($emailServer,25)
#     $smtp.EnableSsl = $true
#     $smtp.credentials = New-Object System.Net.NetworkCredential ("pvh4c@bosch.com", "")
#     $smtp.send($Message)
# }


$test_base64 = [convert]::ToBase64String((Get-Content -Path "C:\Users\TAD6HC\Desktop\report_5_CPU_Ba0VM00298.png" -Encoding byte))
$test_base64