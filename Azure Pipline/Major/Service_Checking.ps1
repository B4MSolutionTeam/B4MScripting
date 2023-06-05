$User = "apac\bmt8hc"
$PWord = ConvertTo-SecureString -String "B4m013209112022@" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord
function checkService
{   
    try {
        $status_service = (Get-Service -Name "VDog MasterService").Status
        if($status_service -eq "Running")
        {
            
            return "passed"
        }
        elseif($status_service -eq "Stopped") {
            return "failed"
        }
    }
    catch {
        return "failed"
    }
    
}

$status_return = Invoke-Command -ComputerName "BA0VM153.de.bosch.com" -ScriptBlock ${Function:checkService} -Credential $Credential
$pat = "e3x5b6ler2dksl44o7dgquhnh5s2k6nqomltnbdjuhligflpyy6a"
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$pat"))
$header = @{
    authorization = "Basic $token"
}
$url = "https://dev.azure.com/B4MService/Software%20Upgrading/_apis/testplan/plans/1/Suites/100/TestPoint?api-version=7.0"
$body = @"
[{
    "id": $(P_Service_Checking),
    "results": {
    "outcome": "$status_return"
    }
}]
"@
Write-Host "ID: $(P_Service_Checking)"
Write-Host "Status return: $status_return"
Invoke-RestMethod -Method Patch -Uri $url -Proxy "http://rb-proxy-sl.bosch.com:8080" -Headers $header -Body $body -ContentType "application/json"