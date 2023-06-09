function Get-PAMPassword 
{   
    $userID = "BMT8HC"
    $uid = $($userID -replace ".*\\").Trim()
    $certThumbprint = "A185ACA52142B152C86792DD8ED7F15EDD4D1BF8"                      #Replace the certificate thumbprint
    $certPath = "Cert:\LocalMachine\My\" + $certThumbprint
    $myCert = Get-ChildItem -Path $certPath
    $appID = "CCP_ITM_ba"                                                           #Replace with AppID
    $safe = "ITM_applications_ba"                                                   #Replace with vault name
    $url = "https://rb-pam-aim.bosch.com/AIMCertAuth/api/Accounts?AppID=$appID&Safe=$safe&UserName=$uid"
    $password = Invoke-RestMethod -Uri $url -Method GET -ContentType "application/json" -Certificate $myCert
    $password = $password.Content.Trim()
    Write-Host "password from pam: "$password
    return $password
}

