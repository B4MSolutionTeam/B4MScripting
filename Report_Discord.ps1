$hookUrl="https://discord.com/api/webhooks/1055060392474312704/YlODnTtVQTLyAHB_oVy22yU2Fgb5eJO4n0mXFpeTI9XnsGvssPHg6VeH3wdTS8D5srim"
$proxyUri = [Uri]$null
$proxy = [System.Net.WebRequest]::GetSystemWebProxy()

$User = "apac\bmt8hc" 
$PWord = ConvertTo-SecureString -String "B4m013209112022@" -AsPlainText -Force 
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord

if ($proxy)
{
    $proxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
    $proxyUri = $proxy.GetProxy("http://rb-proxy-apac.bosch.com:8080")
}
$server_name = "BA0VM153"
$content = @"
Report Daily in $(Get-Date -UFormat "%d/%m/%Y")
"@
$payload = [PSCustomObject]@{
    content = $content
}
Invoke-RestMethod -Uri $hookUrl -Method Post -Body ($payload | ConvertTo-Json) -ContentType 'Application/Json' -Proxy $proxyUri -ProxyCredential $Credential

