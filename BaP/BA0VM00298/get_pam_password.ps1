function Get-PAMPassword 
{   
    $userID = "BMT8HC"
    $uid = $($userID -replace ".*\\").Trim()
    $certThumbprint = "6843BB67DF117B8BA88C05A2DD6854B92CCBB027"                      #Replace the certificate thumbprint
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