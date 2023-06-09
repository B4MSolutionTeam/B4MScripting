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

# $list_Group = @("idm2bcd_B4M_App_Admin_BaP","idm2bcd_B4M_App_ControlCenter-Local_BaP","idm2bcd_B4M_Function_ComponentEditor_BaP","idm2bcd_B4M_Function_EventLog_BaP","idm2bcd_B4M_Function_Jobs_BaP","idm2bcd_B4M_Function_Script_BaP","idm2bcd_B4M_MAE-Support_ATMO_BaP","idm2bcd_B4M_MAE-Support_Atrotech_BaP","idm2bcd_B4M_MAE-Support_AuH_BaP","idm2bcd_B4M_MAE-Support_BCI_BaP","idm2bcd_B4M_MAE-Support_FCM_BaP","idm2bcd_B4M_MAE-Support_Gluth_BaP","idm2bcd_B4M_MAE-Support_Ruhlamat_BaP","idm2bcd_B4M_MAE-Support_Silberhorn_BaP","idm2bcd_B4M_MAE-Support_Strama_BaP","idm2bcd_B4M_MAE-Support_TEF1_BaP","idm2bcd_B4M_MAE-Support_TEF2_BaP","idm2bcd_B4M_MAE_Owner_BaP_Actuator_LV1","idm2bcd_B4M_MAE_Owner_BaP_Actuator_LV2","idm2bcd_B4M_MAE_Owner_BaP_CRI2_LV1","idm2bcd_B4M_MAE_Owner_BaP_CRI2_LV2","idm2bcd_B4M_MAE_Owner_BaP_CRI3_LV1","idm2bcd_B4M_MAE_Owner_BaP_CRI3_LV2","idm2bcd_B4M_MAE_Owner_BaP_DLL_LV1","idm2bcd_B4M_MAE_Owner_BaP_DLL_LV2","idm2bcd_B4M_MAE_Owner_BaP_EIC_LV1","idm2bcd_B4M_MAE_Owner_BaP_EIC_LV2","idm2bcd_B4M_MAE_Owner_BaP_EV_LV1","idm2bcd_B4M_MAE_Owner_BaP_EV_LV2","idm2bcd_B4M_MAE_Owner_BaP_FCEV_LV1","idm2bcd_B4M_MAE_Owner_BaP_FCEV_LV2","idm2bcd_B4M_MAE_Owner_BaP_FCM_LV1","idm2bcd_B4M_MAE_Owner_BaP_FCM_LV2","idm2bcd_B4M_MAE_Owner_BaP_HDEV_LV1","idm2bcd_B4M_MAE_Owner_BaP_HDEV_LV2","idm2bcd_B4M_MAE_Owner_BaP_MFE-ECR_LV1","idm2bcd_B4M_MAE_Owner_BaP_MFE-ECR_LV2","idm2bcd_B4M_MAE_Owner_BaP_Nozzle_LV1","idm2bcd_B4M_MAE_Owner_BaP_Nozzle_LV2","idm2bcd_B4M_MAE_Owner_BaP_PQA_LV1","idm2bcd_B4M_MAE_Owner_BaP_PQA_LV2","idm2bcd_B4M_MAE_Owner_BaP_QMM_LV1","idm2bcd_B4M_MAE_Owner_BaP_QMM_LV2","idm2bcd_B4M_MAE_Owner_BaP_SE_LV1","idm2bcd_B4M_MAE_Owner_BaP_SE_LV2","idm2bcd_B4M_MAE_Owner_BaP_SOFC_LV1","idm2bcd_B4M_MAE_Owner_BaP_SOFC_LV2","idm2bcd_B4M_MAE_Owner_BaP_SP_LV1","idm2bcd_B4M_MAE_Owner_BaP_SP_LV2","idm2bcd_B4M_MAE_Owner_BaP_TEF1_LV1","idm2bcd_B4M_MAE_Owner_BaP_TEF1_LV2","idm2bcd_B4M_MAE_Owner_BaP_TEF2_LV1","idm2bcd_B4M_MAE_Owner_BaP_TEF2_LV2","idm2bcd_B4M_MAE_Owner_BaP_TEF3_LV1","idm2bcd_B4M_MAE_Owner_BaP_TEF3_LV2","idm2bcd_B4M_MAE_PQT_BaP_Actuator","idm2bcd_B4M_MAE_PQT_BaP_CRI2","idm2bcd_B4M_MAE_PQT_BaP_CRI3","idm2bcd_B4M_MAE_PQT_BaP_DLL","idm2bcd_B4M_MAE_PQT_BaP_EIC","idm2bcd_B4M_MAE_PQT_BaP_EV","idm2bcd_B4M_MAE_PQT_BaP_FCEV","idm2bcd_B4M_MAE_PQT_BaP_FCM","idm2bcd_B4M_MAE_PQT_BaP_HDEV","idm2bcd_B4M_MAE_PQT_BaP_MFE-ECR","idm2bcd_B4M_MAE_PQT_BaP_Nozzle","idm2bcd_B4M_MAE_PQT_BaP_PQA","idm2bcd_B4M_MAE_PQT_BaP_QMM","idm2bcd_B4M_MAE_PQT_BaP_SE","idm2bcd_B4M_MAE_PQT_BaP_SOFC","idm2bcd_B4M_MAE_PQT_BaP_SP","idm2bcd_B4M_MAE_PQT_BaP_TEF1","idm2bcd_B4M_MAE_PQT_BaP_TEF2","idm2bcd_B4M_MAE_PQT_BaP_TEF3","idm2bcd_B4M_MAE_Setter_BaP_Actuator","idm2bcd_B4M_MAE_Setter_BaP_CRI2","idm2bcd_B4M_MAE_Setter_BaP_CRI3","idm2bcd_B4M_MAE_Setter_BaP_DLL","idm2bcd_B4M_MAE_Setter_BaP_EIC","idm2bcd_B4M_MAE_Setter_BaP_EV","idm2bcd_B4M_MAE_Setter_BaP_FCEV","idm2bcd_B4M_MAE_Setter_BaP_FCM","idm2bcd_B4M_MAE_Setter_BaP_HDEV","idm2bcd_B4M_MAE_Setter_BaP_MFE-ECR","idm2bcd_B4M_MAE_Setter_BaP_Nozzle","idm2bcd_B4M_MAE_Setter_BaP_PQA","idm2bcd_B4M_MAE_Setter_BaP_QMM","idm2bcd_B4M_MAE_Setter_BaP_SE","idm2bcd_B4M_MAE_Setter_BaP_SOFC","idm2bcd_B4M_MAE_Setter_BaP_SP","idm2bcd_B4M_MAE_Setter_BaP_TEF1","idm2bcd_B4M_MAE_Setter_BaP_TEF2","idm2bcd_B4M_MAE_Setter_BaP_TEF3","idm2bcd_B4M_MAE_Support_Qualisoft_BaP","idm2bcd_B4M_MES-Support_BCI_BaP","idm2bcd_B4M_MES-Support_TEF_BaP","idm2bcd_B4M_Plant_CrossSection_HSE_BaP_LV2","idm2bcd_B4M_Plant_CrossSection_ITM_BaP_LV1","idm2bcd_B4M_Plant_CrossSection_ITM_BaP_LV2","idm2bcd_B4M_Plant_SolutionExpert-Operator_BaP","idm2bcd_B4M_Plant_SolutionExpert-Plant_BaP","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_Actuator","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_CRI2","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_CRI3","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_DLL","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_EIC","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_EV","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_FCEV","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_FCM","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_HDEV","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_HDEV6","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_MFE-ECR","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_Nozzle","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_PQA","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_QMM","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_SE","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_SOFC","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_SP","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_TEF1","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_TEF2","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_TEF3","idm2bcd_B4M_Service_TEF_BaP_LV1","idm2bcd_B4M_Service_TEF_BaP_LV2","idm2bcd_B4M_TempAccess_Component_BaP","idm2bcd_B4M_MAE-Support_Wiso_BaP")
# $list_member = @()
# foreach($group in $list_Group)
# {
#     $rootou = "CN=$group,ou=securitygroups,ou=ci-idm2bcd,ou=applications,dc=de,dc=bosch,dc=com"
#     $Searcher = New-Object DirectoryServices.DirectorySearcher
#     $Searcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$($rootou)")
#     try{
#         $user = $Searcher.FindAll()
#     }catch{
#         Write-Host "Group $entry not found" -ForegroundColor Red
#     }
#     $list_member += $user.Properties.member
# }

# foreach($member in $list_member )
# {
#     $rootou = "$member"
#     $Searcher = New-Object DirectoryServices.DirectorySearcher
#     $Searcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$($rootou)")
#     try{
#         $user = $Searcher.FindAll()
#     }catch{
#         Write-Host "Group $entry not found" -ForegroundColor Red
#     }
#     write-host $user.Properties.mail
# }
# $certificate_properties = Get-ChildItem -Path "Cert:\LocalMachine\My\"

Invoke-Command -ComputerName "BA0VM060.de.bosch.com" -ScriptBlock {[System.Net.Dns]::GetHostByName($env:computerName).HostName} -Credential $Credential

# $csv_content = Import-Csv -Path "\\ba00fb02.de.bosch.com\B4M\Automation\Automation_Script\Thumbprint_Server.csv"
# $server_name = "BA0VM153.de.bosch.com"
# foreach($thumbprint in $csv_content)
# {
#     if($thumbprint.ServerName -eq $server_name)
#     {
#         Write-Host $thumbprint.Thumbprint
#     }
# }

