Write-Host($([System.Net.Dns]::GetHostByName($env:computerName).HostName))