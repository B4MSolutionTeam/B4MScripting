# $username = "Apac\ems8hc"
# $password = ConvertTo-SecureString "Covadmin2024" -AsPlainText -Force
# Write-Host($password)
# $cred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)

# $server_01 = New-PSSession -ComputerName "BA0VM153.de.bosch.com" -Credential $(New-Object System.Management.Automation.PSCredential -ArgumentList ("APAC\BMT8HC", $(ConvertTo-SecureString "B4m013209112022@" -AsPlainText -Force)))
# $content  = @"
# "@
# Get-PSSession
# Invoke-Command -Session $server_01 -ScriptBlock {
#   Copy-Item -Path D:\Test_Duy\export_Adminlog.ps1 -Destination D:\Test_Duy\export_Adminlog_BMT.ps1
# }
# Remove-PSSession -Session $server_01

# $a = ((Get-Date).AddDays(-1)).ToString("dd/MM/yyyy")
# Write-Host($a)


# $backup_path = "C:\Users\TAD6HC\Desktop\DuyPython\Bao_Bao"
# $backup_file_list = Get-ChildItem -Path $backup_path "*backup"
# Write-Host($backup_file_list)
# Invoke-Command -ComputerName "BA0VM060.de.bosch.com" -ScriptBlock {[System.Net.Dns]::GetHostName()} -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList ("APAC\BMT8HC", (ConvertTo-SecureString "B4m013209112022@" -AsPlainText -Force)))
# "Invoke-Command -ComputerName 'BA0VM060.de.bosch.com' -ScriptBlock {Set-Content -Path D:\PowerBi_Export_File_Test\ComponentTreeIni\test.txt -Value 'dsadad'} -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList ('APAC\BMT8HC', (ConvertTo-SecureString 'B4m013209112022@' -AsPlainText -Force)))"

#     $scheduleObject = New-Object -ComObject schedule.service

#     $scheduleObject.connect()

#     $rootFolder = $scheduleObject.GetFolder("\")

#     $rootFolder.CreateFolder("PoshTasks")

# $scheduleObject = New-Object -ComObject schedule.service
# $scheduleObject.connect()
# $root= $scheduleObject.GetFolder("\")
# $subfolder  = $root.GetFolders(0)
# $temp_list_folder = @()
# foreach($folder in $subfolder)
# {
#     $folder_name = [string]($folder.Name)
#     $temp_list_folder += $folder_name
# }
# if("Automation Task" -in $temp_list_folder)
# {
#     $list_task_schedule = (Get-ScheduledTask).TaskName
#     if("Powershell_Test" -in $list_task_schedule)
#     {
#         $service_name = "XblAuthManager"
#         create_report_file($service_name)
#     }
#     else
#     {
#         SCHTASKS /CREATE /SC DAILY /TN "\Automation Task\Powershell_Test" /TR "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /ST 11:00 /RU "APAC\TAD6HC"
#         $service_name = "XblAuthManager"
#         create_report_file($service_name)
#     }
# }
# else
# {
#     $scheduleObject = New-Object -ComObject schedule.service
#     $scheduleObject.connect()
#     $rootFolder = $scheduleObject.GetFolder("\")
#     $rootFolder.CreateFolder("Automation Task")

#     $list_task_schedule = (Get-ScheduledTask).TaskName
#     if("Powershell_Test" -in $list_task_schedule)
#     {
#         $service_name = "XblAuthManager"
#         create_report_file($service_name)
#     }
#     else
#     {
#         SCHTASKS /CREATE /SC DAILY /TN "\Test\Test1\Powershell_Test" /TR "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /ST 11:00 /RU "APAC\TAD6HC"
#         $service_name = "XblAuthManager"
#         create_report_file($service_name)
#     }
# }
# Set-Content -Value "dsadad" -Path D:\PowerBi_Export_File_Test\ComponentTreeIni
# Test-NetConnection -ComputerName "BA0VM060.de.bosch.com" -Port 445
# $con = net use \\BA00FB02.DE.BOSCH.COM\Bulk02$
# Write-Host $con."Remote Name"
# function test($path_json)
# {
#     $disk_info_json = Get-Content -Raw $path_json | ConvertFrom-Json
#     for ($i = 0; $i -lt ($disk_info_json.data).Count; $i++) {
#         if(($disk_info_json.data[$i].disk_info_alert).Length -eq 5)
#         {
#             Write-Host($disk_info_json.data[$i].provider_name)
#         }
#     }
# }
# test("C:\hello\disk_info_bulk.json")
# $email_content = @"
# <p>Test Email. Please ignore</p>
# "@
# $emailServer = "rb-smtp-auth.rbesz01.com"
# $htmlBody = $email_content
# Write-Host($htmlBody)
# $Message = New-Object System.Net.Mail.MailMessage
# # duy.tathai@vn.bosch.com
# # Hc1_CI_B4M_OperationProject@bcn.bosch.com
# $Message.From = "duy.tathai@vn.bosch.com"
# $Message.To.Add("duy.tathai@vn.bosch.com")


# $Message.IsBodyHtml = $true
# $Message.Subject = "Test Email. Please ignore"
# $Message.Body = $htmlBody

# $Smtp = New-Object Net.Mail.smtpclient($emailServer,25)
# $smtp.EnableSsl = $true
# $smtp.credentials = New-Object System.Net.NetworkCredential ("bmt8hc@bosch.com", "B4m013209112022@")
# $smtp.send($Message)
# $token= "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6InhueE5fUHFzYU9lOG1iWkJDOTl5cXUwYmhDOCIsImtpZCI6InhueE5fUHFzYU9lOG1iWkJDOTl5cXUwYmhDOCJ9.eyJhdWQiOiJtaWNyb3NvZnQ6aWRlbnRpdHlzZXJ2ZXI6YTA2ZTdhZGUtNjc5ZS00OTE1LWIyOWItMWRhNThmYzQ3YWRiIiwiaXNzIjoiaHR0cDovL3N0ZnMuYm9zY2guY29tL2FkZnMvc2VydmljZXMvdHJ1c3QiLCJpYXQiOjE2NzkwNDI4OTYsIm5iZiI6MTY3OTA0Mjg5NiwiZXhwIjoxNjc5MDQ2NDk2LCJkb21haW4iOiJhcGFjLmJvc2NoLmNvbSIsInNhbWFjY291bnRuYW1lIjoiYm10OGhjIiwidXBuIjoiYm10OGhjQGJvc2NoLmNvbSIsImdyb3VwcyI6WyJSQl9URFNfVEJTaGFyZV9SX1VGIiwiUkJfRXh0ZW5kZWRJbnRlcm5ldF9DaGF0IiwiUkJfSW50ZXJuZXRBY2Nlc3MiLCJwbmctZGlyLW5ldGxvZ29uLXIiLCJJRE0yQkNEX1BBTV9DSU9TQl9iYTB2bTA2MF9TUlZfQWRtaW4iLCJJRE0yQkNEX1BBTV9DSU9TQl9iYTB2bTA2MV9TUlZfQWRtaW4iLCJGZV9GaWxlc2hhcmVfUm9sZV8wMDEzOTUyODVfTEYiLCJJZE0yQkNEX1BBTV9JVE1fYXBwbGljYXRpb25zX2JhX0FkbWlucyIsIkZvcmVzdCBVc2VycyIsIlJCU05fQUxMIiwiQkxfQk9TQ0hfR0ciLCJCTF9CT1NDSF9BTExfTEYiLCJFU0JfQk9TQ0hfQUxMX0xGIiwiRGVfRmlsZXNoYXJlX1JvbGVfMDAxNDY0OTkyX0xGIiwiRG9tYWluIFVzZXJzIiwiQ25nX0dNX0xSIiwiU0dQX1VzZXJzLUNvbW1vbl9MRiIsIkNOR19HTV9URUYtVmlkZW9fTFIiXSwiYXBwdHlwZSI6IkNvbmZpZGVudGlhbCIsImFwcGlkIjoiYTA2ZTdhZGUtNjc5ZS00OTE1LWIyOWItMWRhNThmYzQ3YWRiIiwiYXV0aG1ldGhvZCI6InVybjpvYXNpczpuYW1lczp0YzpTQU1MOjIuMDphYzpjbGFzc2VzOlBhc3N3b3JkUHJvdGVjdGVkVHJhbnNwb3J0IiwiYXV0aF90aW1lIjoiMjAyMy0wMy0xN1QwODo0ODoxNS45NDVaIiwidmVyIjoiMS4wIiwic2NwIjoib3BlbmlkIn0.UA0h4knGS2xQgz-k7TqN2cAEni0GMKZolFCEcrPJSUPUA6SA6IaW9pBc5FMgtp9XO7os4w3yUYrAxQnyUMTn-76YQ1LmjE7iSigG4YIrqgvXd8NnG64U-Nwgq9Be6MTDwpYUWo63tA7iU12jTUTlpBOmqf29JFpPynQ65NLN4aVtnBBeVpEYmVcnLs8joVr40WhFaONSQUqw4UlETci7uRAMFd2Owi2WwM2-tN-UmR2XHucEKIlTf5JnH_HQmGDbF1vLCjdhWEp5jcXpDrzcpFjyHn4xaepKne_VHEmiT07QaGIBeIoj1rBBZKWtQpb7_qZW0hxZJvebLXCdPc4qTg"
# $proxyUri = [Uri]$null
# $proxy = [System.Net.WebRequest]::GetSystemWebProxy()

# $User = "apac\bmt8hc"
# $PWord = ConvertTo-SecureString -String "B4m013209112022@" -AsPlainText -Force
# $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord
# if ($proxy)
# {
#     $proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
#     $proxyUri = $proxy.GetProxy("http://rb-proxy-apac.bosch.com:8080")
# }
# $Uri = "https://cls.seccom.bosch.com/iptt/templates/323/"
# $Headers = @{
#         Authorization = "Bearer $token"
#         csrf_token = 'NnXysUvyofKeER9mma5dDgfVGV89JuyfBadmqGyRkgsnITIVbDpaE3zjSly8q555'
#     }

# Invoke-RestMethod -Method Get -Uri $Uri -Headers $Headers -ContentType "application/json; charset=utf-8" -Proxy $proxyUri -ProxyCredential $Credential -UseBasicParsing


# function check_out_function($password_string)
# {
#     try {
        
#         $status_return = D:\vdClient\VDogAutoCheckOut.exe /rd:d:\vdCA /at:c /dirR:\Ba\test\Json3 /CID:CDFCBC9C02CB4E238B91125CD1E38AF6 /Account:bmt8hc /Password:$password_string /Domain:APAC
#         # Write-Host($status_return)
#         $list_char_status = $status_return.Split(" ")
#         if($list_char_status -contains "INF")
#         {
#             return "Check Out successfully"
#         }
#         else
#         {
#             return "Check Out fail."
#         }
#     }
#     catch [System.Exception]{
#         return "vDog server is in maintainance, can't proceed this process" 
#     }
    
# }
# function check_in_function($password_string)
# {   
#     try {
#         $status_return = D:\vdClient\VDogAutoCheckIn.exe /RD:D:\vdCA /AT:C /CFile:D:\AutoCheckIn.ini /Password:$password_string /Account:bmt8hc /Domain:APAC
        
#         if($status_return.Length -eq 0)
#         {
#             return "Check In successfully"
#         }
#         elseif ($status_return.Length -ne 0) {
#             if($status_return -contains "ERR SQLException")
#             {
#                 return "Database is probaly already opened by another engine in another Window session, can't proceed this process"
#             }
#             elseif ($status_return -contains "[22313]") {
#                 return "There is no backup version created"
#             } 
#             else {
#                 return "Check In proceed fail"
#             }
#         } 
#     }
#     catch [System.Exception]{
#         return "vDog server is in maintainance, can't proceed this process"
#     }
# }

# function create_json_report()
# {
#     $password = "B4m013209112022@"
#     $status_check_in = check_in_function($password)
#     $status_check_out = check_out_function($password)
#     $data_json = @{data = @{}}
#     $data_json["data"].Add("function","[Automation] Routine Check In/Check Out")
#     $data_json["data"].Add("time", "$(Get-Date -UFormat "%d/%m/%Y")")
#     $data_json["data"].Add("exist", "True")
#     $data_json["data"].Add("server", "$([System.Net.Dns]::GetHostName())")
#     $status = @{

#     }
#     $status.Add("status_check_in", "$status_check_in")
#     $status.Add("status_check_out", "$status_check_out")
#     $data_json["data"].Add("status",$status)


#     if(Test-Path -Path D:\vdSA\Report_Daily\report_1_153.json)
#     {
#         Remove-Item -Path "D:\vdSA\Report_Daily\report_1_153.json"
#         $data_json | ConvertTo-Json | Out-File "D:\vdSA\Report_Daily\report_1_153.json"
#     }
#     else {
        
#         $data_json | ConvertTo-Json | Out-File "D:\vdSA\Report_Daily\report_1_153.json"
#     }
# }
# create_json_report

# Invoke-Command -ComputerName "BA0VM153.de.bosch.com" -ScriptBlock {[System.Net.Dns]::GetHostName() ; [System.Net.Dns]::GetHostName()} -Credential (New-Object System.Management.Automation.PSCredential -ArgumentList ("APAC\BMT8HC", (ConvertTo-SecureString "B4m013209112022@" -AsPlainText -Force)))

# $User = "apac\bmt8hc"
# $PWord = ConvertTo-SecureString -String "B4m013209112022@" -AsPlainText -Force
# $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord
# # $proxyUri = ""
# # if ($proxy)
# # {
# #     $proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
# #     $proxyUri = $proxy.GetProxy("http://rb-proxy-sl.bosch.com:8080")
# # }
# # # ymjac7byuge75qff3fu6q2cecoblg7leqqcuahq62ckja2fbmpkq Duy_Token

# # $uri = "https://dev.azure.com/B4MService/Software%20Upgrading/_apis/test/plans?api-version=5.0"
# $pat = "ymjac7byuge75qff3fu6q2cecoblg7leqqcuahq62ckja2fbmpkq"
# $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($pat)"))

# $header = @{
#     authorization = "Basic $token"
# }

# Invoke-RestMethod -Method Get -Uri "https://dev.azure.com/B4MService/Software%20Upgrading/_apis/test/plans?api-version=5.0" -Proxy "http://rb-proxy-sl.bosch.com:8080" -Headers $header


# $list_query | Out-File -FilePath C:\hello\query.txt -Encoding default
# $list_group = @("idm2bcd_B4M_App_Admin_BaP","idm2bcd_B4M_App_ControlCenter-Local_BaP","idm2bcd_B4M_Function_ComponentEditor_BaP","idm2bcd_B4M_Function_EventLog_BaP","idm2bcd_B4M_Function_Jobs_BaP","idm2bcd_B4M_Function_Script_BaP","idm2bcd_B4M_MAE-Support_ATMO_BaP","idm2bcd_B4M_MAE-Support_Atrotech_BaP","idm2bcd_B4M_MAE-Support_AuH_BaP","idm2bcd_B4M_MAE-Support_BCI_BaP","idm2bcd_B4M_MAE-Support_FCM_BaP","idm2bcd_B4M_MAE-Support_Gluth_BaP","idm2bcd_B4M_MAE-Support_Ruhlamat_BaP","idm2bcd_B4M_MAE-Support_Silberhorn_BaP","idm2bcd_B4M_MAE-Support_Strama_BaP","idm2bcd_B4M_MAE-Support_TEF1_BaP","idm2bcd_B4M_MAE-Support_TEF2_BaP","idm2bcd_B4M_MAE_Owner_BaP_Actuator_LV1","idm2bcd_B4M_MAE_Owner_BaP_Actuator_LV2","idm2bcd_B4M_MAE_Owner_BaP_CRI2_LV1","idm2bcd_B4M_MAE_Owner_BaP_CRI2_LV2","idm2bcd_B4M_MAE_Owner_BaP_CRI3_LV1","idm2bcd_B4M_MAE_Owner_BaP_CRI3_LV2","idm2bcd_B4M_MAE_Owner_BaP_DLL_LV1","idm2bcd_B4M_MAE_Owner_BaP_DLL_LV2","idm2bcd_B4M_MAE_Owner_BaP_EIC_LV1","idm2bcd_B4M_MAE_Owner_BaP_EIC_LV2","idm2bcd_B4M_MAE_Owner_BaP_EV_LV1","idm2bcd_B4M_MAE_Owner_BaP_EV_LV2","idm2bcd_B4M_MAE_Owner_BaP_FCEV_LV1","idm2bcd_B4M_MAE_Owner_BaP_FCEV_LV2","idm2bcd_B4M_MAE_Owner_BaP_FCM_LV1","idm2bcd_B4M_MAE_Owner_BaP_FCM_LV2","idm2bcd_B4M_MAE_Owner_BaP_HDEV_LV1","idm2bcd_B4M_MAE_Owner_BaP_HDEV_LV2","idm2bcd_B4M_MAE_Owner_BaP_MFE-ECR_LV1","idm2bcd_B4M_MAE_Owner_BaP_MFE-ECR_LV2","idm2bcd_B4M_MAE_Owner_BaP_Nozzle_LV1","idm2bcd_B4M_MAE_Owner_BaP_Nozzle_LV2","idm2bcd_B4M_MAE_Owner_BaP_PQA_LV1","idm2bcd_B4M_MAE_Owner_BaP_PQA_LV2","idm2bcd_B4M_MAE_Owner_BaP_QMM_LV1","idm2bcd_B4M_MAE_Owner_BaP_QMM_LV2","idm2bcd_B4M_MAE_Owner_BaP_SE_LV1","idm2bcd_B4M_MAE_Owner_BaP_SE_LV2","idm2bcd_B4M_MAE_Owner_BaP_SOFC_LV1","idm2bcd_B4M_MAE_Owner_BaP_SOFC_LV2","idm2bcd_B4M_MAE_Owner_BaP_SP_LV1","idm2bcd_B4M_MAE_Owner_BaP_SP_LV2","idm2bcd_B4M_MAE_Owner_BaP_TEF1_LV1","idm2bcd_B4M_MAE_Owner_BaP_TEF1_LV2","idm2bcd_B4M_MAE_Owner_BaP_TEF2_LV1","idm2bcd_B4M_MAE_Owner_BaP_TEF2_LV2","idm2bcd_B4M_MAE_Owner_BaP_TEF3_LV1","idm2bcd_B4M_MAE_Owner_BaP_TEF3_LV2","idm2bcd_B4M_MAE_PQT_BaP_Actuator","idm2bcd_B4M_MAE_PQT_BaP_CRI2","idm2bcd_B4M_MAE_PQT_BaP_CRI3","idm2bcd_B4M_MAE_PQT_BaP_DLL","idm2bcd_B4M_MAE_PQT_BaP_EIC","idm2bcd_B4M_MAE_PQT_BaP_EV","idm2bcd_B4M_MAE_PQT_BaP_FCEV","idm2bcd_B4M_MAE_PQT_BaP_FCM","idm2bcd_B4M_MAE_PQT_BaP_HDEV","idm2bcd_B4M_MAE_PQT_BaP_MFE-ECR","idm2bcd_B4M_MAE_PQT_BaP_Nozzle","idm2bcd_B4M_MAE_PQT_BaP_PQA","idm2bcd_B4M_MAE_PQT_BaP_QMM","idm2bcd_B4M_MAE_PQT_BaP_SE","idm2bcd_B4M_MAE_PQT_BaP_SOFC","idm2bcd_B4M_MAE_PQT_BaP_SP","idm2bcd_B4M_MAE_PQT_BaP_TEF1","idm2bcd_B4M_MAE_PQT_BaP_TEF2","idm2bcd_B4M_MAE_PQT_BaP_TEF3","idm2bcd_B4M_MAE_Setter_BaP_Actuator","idm2bcd_B4M_MAE_Setter_BaP_CRI2","idm2bcd_B4M_MAE_Setter_BaP_CRI3","idm2bcd_B4M_MAE_Setter_BaP_DLL","idm2bcd_B4M_MAE_Setter_BaP_EIC","idm2bcd_B4M_MAE_Setter_BaP_EV","idm2bcd_B4M_MAE_Setter_BaP_FCEV","idm2bcd_B4M_MAE_Setter_BaP_FCM","idm2bcd_B4M_MAE_Setter_BaP_HDEV","idm2bcd_B4M_MAE_Setter_BaP_MFE-ECR","idm2bcd_B4M_MAE_Setter_BaP_Nozzle","idm2bcd_B4M_MAE_Setter_BaP_PQA","idm2bcd_B4M_MAE_Setter_BaP_QMM","idm2bcd_B4M_MAE_Setter_BaP_SE","idm2bcd_B4M_MAE_Setter_BaP_SOFC","idm2bcd_B4M_MAE_Setter_BaP_SP","idm2bcd_B4M_MAE_Setter_BaP_TEF1","idm2bcd_B4M_MAE_Setter_BaP_TEF2","idm2bcd_B4M_MAE_Setter_BaP_TEF3","idm2bcd_B4M_MAE_Support_Qualisoft_BaP","idm2bcd_B4M_MES-Support_BCI_BaP","idm2bcd_B4M_MES-Support_TEF_BaP","idm2bcd_B4M_Plant_CrossSection_HSE_BaP_LV2","idm2bcd_B4M_Plant_CrossSection_ITM_BaP_LV1","idm2bcd_B4M_Plant_CrossSection_ITM_BaP_LV2","idm2bcd_B4M_Plant_SolutionExpert-Operator_BaP","idm2bcd_B4M_Plant_SolutionExpert-Plant_BaP","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_Actuator","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_CRI2","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_CRI3","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_DLL","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_EIC","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_EV","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_FCEV","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_FCM","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_HDEV","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_HDEV6","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_MFE-ECR","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_Nozzle","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_PQA","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_QMM","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_SE","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_SOFC","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_SP","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_TEF1","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_TEF2","idm2bcd_B4M_Plant_SolutionExpert-ValueStream_BaP_TEF3","idm2bcd_B4M_Service_TEF_BaP_LV1","idm2bcd_B4M_Service_TEF_BaP_LV2","idm2bcd_B4M_TempAccess_Component_BaP","idm2bcd_B4M_MAE-Support_Wiso_BaP")

# $rootou = "CN=GUA3RU,OU=G,OU=Useraccounts,OU=Fe,DC=de,DC=bosch,DC=com"
$list_ComponentID = @("0F2CDE661BF748A2ABEB631CE93706D0","1979732EA6834099B93365F7BBC3F60F","05B3074FD9514EA1BF36993A13E7EFF3","07BCA15E3B634373ABD2A956FB80CA84","A68861D21AC74054AF5495FD77044822","27B5363D7ACD4746B610805AB1C8EBEC","2F6EBD9C866A4B09A1FD594FA22179A2","9DEC1124FECD44CC95243EF686F9BB65","606F8E7429C84B4E9944BE83886BE5A6","754FA8A63CA64239A680682C0D775BFC","8223D426E38E4A409C069D05951BE290","12E5982B12D5454EA6EC1ABEF8651959","E34E6DF90D7F4220B38C73855EF0FF7D","10BF9D4635594415A05DB2343B662418","974C7BFB2F0E443EAE4A2880B3BBDD77","D6908EABFA00465D85A8911D4D1F2D7E","B1492BDCCA32471D804CE208809440B8","ABF2EF3BD3054946942D5A67138F10ED","766615A771C34222815372AA348AF0F7","95A07ACA28D3449CB65B315EBABA879D","AFBA1334EBA642238585F626C1A8FBC1","BFDAC37113EF46A4A2FDB5148910B330","C2F74DB9B8C64D338B6EB73A91D43545","CD430B75A2974FE3A2D9A915FFA8884F","E65658069C0D44DA8198E15CF78F7D63","9B5B94A8B83643AE985881F75852A88F","D029372925DE4119AFC54EFBB0BEEE8E","8E87E3E31C2A46C099A38A1B687DA04E","53D56F79844C4EE2BDF046727C324561","D97825CD55834D6EBD2B14A5A9C27003","187A3C6E6564459FA1822857E67447E0","CAEB71D72F0F414B82668CFD48F5F500","163D7EA19E344DE18E411B5B1B31FC98","5631A39D6D6B42CBB27EEA7B46CD5D29","3329BFF164DB432793A0A0D34BCEFD2D","043956AD47B44C3F819168068DEAC329","670C405ABE4848CA84E6594B12BBB6A2","C80055D4286C49E4A01650197367D8FE","14E255D056834581B7E2299EF9D4E297","04CFBDCB21DF43178A56AE02AB98A4C8","5619788BC4BC491EA15FC17AD7211AE9","5765A2C520354C28ACAD31AFDB13FEE7","77F1D7E7C85146EBA7BAF157F73794C9","28F3CEE5438E4A52AB9F40F57136271E","7D0A0AD7BD834189A3AD66A54D6791FB","F83771EBEE444F938FB58FFE8DD766C2","2E1AE24BF6E24E9792AEB0F937EB4901","8DCA4325923544B5A58B89343A1F66ED","BB7B6C4F8813475999B8A7A89EA24DF0","EF55F7F5C0ED4776A066DE8496B3F752","DDD794BF17F642AF893F584C114002C0")
$list_File_CSV = (Get-ChildItem -Path "C:\hello").FullName
# foreach($componentID in $list_ComponentID)
# {
#     foreach($csv in $list_File_CSV)
#     {
#         # $csv_Content = Get-Content -Path $csv
#         # foreach($eachLine_CSV in $csv_Content)
#         # {
#         #     # if($componentID -contains $eachLine_CSV)
#         #     # {
#         #     #     Write-Host $eachLine_CSV
#         #     # }
#         #     Write-Host $eachLine_CSV
#         # }
        
#         $csv_content = Import-Csv -Path $csv -Delimiter ";"
#         foreach($eachComponent in $csv_content.ComponentID)
#         {
#             # if($componentID -eq $eachComponent)
#             # {
#             #     write-host "ComponentID: $componentID in File: $csv"
#             # }
            
#         }
#         Start-Sleep 10
        
#     }
# }

foreach($componentID in $list_ComponentID)
{
    $a = Invoke-Sqlcmd -ServerInstance "Ba0vsql01.de.bosch.com" -Database "DB_MAE_CM_SQL" -Query "Select [ScanDate] ,[ComponentID] ,[SNAFileName] from T_CM_AV_SNA_File_Scan_Status where [ComponentID] = '$componentID' and [IsSNAFileAffected] = '1'" -Username "MAE_CM_INTERFACE" -Password "hiJmVZ3w4v7YR7W"
    $a | Out-File C:\test\sql.txt -Append
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
    return $email_string 
}


# 
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
    $Message.To.Add("duy.tathai@vn.bosch.com")  
    # $Message.To.Add("Hc1_CI_B4M_OperationProject@bcn.bosch.com")
    

    $Message.IsBodyHtml = $true
    $Message.Subject = "Splunk Chart Report Daily $((Get-Date).ToString("dd/MM/yyyy"))"
    $Message.Body = $htmlBody

    $Smtp = New-Object Net.Mail.smtpclient($emailServer,25)
    $smtp.EnableSsl = $true
    $smtp.credentials = New-Object System.Net.NetworkCredential ("bmt8hc@bosch.com", $password)
    $smtp.send($Message)
}

# $return_value = email_content -path_report "C:\test" -path_server "C:\test\duy.txt"

# send_mail_total -password "h0B5uL851Vz3" -email_content $return_value