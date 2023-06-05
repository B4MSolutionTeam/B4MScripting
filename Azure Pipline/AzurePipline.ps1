$User = "apac\bmt8hc"
$PWord = ConvertTo-SecureString -String "B4m013209112022@" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord

$request_return = Invoke-Command -ComputerName "BA0VM00246.de.bosch.com" -ScriptBlock {
    $pat = "e3x5b6ler2dksl44o7dgquhnh5s2k6nqomltnbdjuhligflpyy6a"
    $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($pat)"))
    $header = @{
        authorization = "Basic $token"
    }
    $url = "https://dev.azure.com/B4MService/Software%20Upgrading/_apis/testplan/Plans/1/suites?api-version=7.0"
    Invoke-RestMethod -Method Get -Uri $url -Proxy "http://rb-proxy-sl.bosch.com:8080" -Headers $header -ContentType "application/json"
} -Credential $Credential


$test_suite_list = ($request_return | ConvertTo-Json -Depth 10) | ConvertFrom-Json
$date = ("2022-8").Split("-")
$evn = "Q-Ent" # Sử dụng variable gr để lấy dữ liệu
$test_type = "Major" # Sử dụng variable gr để lấy dữ liệu
$id_env = 0
$id_year = 0
$id_Q = 0
$id_Month = 0
$id_type = 0
$quarterMonth = @{
    "1" = "Q1";
    "2" = "Q1";
    "3" = "Q1";
    "4" = "Q2";
    "5" = "Q2";
    "6" = "Q2";
    "7" = "Q3";
    "8" = "Q3";
    "9" = "Q3";
    "10" = "Q4";
    "11" = "Q4";
    "12" = "Q4"
}
foreach($test_suite in $test_suite_list.value)
{
    if($test_suite.name -eq $evn)
    {
        $id_env = $test_suite.id
    }
    if($id_env -gt 0)
    {
        if($test_suite.parentSuite.id -eq $id_env -and $test_suite.name -eq $date[0])
        {
            $id_year = $test_suite.id
        }
    }
    if($id_year -gt 0)
    {
        if($test_suite.parentSuite.id -eq $id_year -and $test_suite.name -eq $quarterMonth[$date[1]])
        {
            $id_Q = $test_suite.id
        }
    }
    if($id_Q -gt 0)
    {
        if($test_suite.parentSuite.id -eq $id_Q -and $test_suite.name -eq "M$($date[1])")
        {
            $id_Month = $test_suite.id
        }
    }
    if($id_Month -gt 0)
    {
        if($test_suite.parentSuite.id -eq $id_Month -and $test_suite.name -eq $test_type)
        {
            $id_type = $test_suite.id
        }
    }
}
write-host($id_type)

$testpoint_list_data = Invoke-Command -ComputerName "BA0VM00246.de.bosch.com" -ScriptBlock {
    param(
        $id_type
    )
    $pat = "e3x5b6ler2dksl44o7dgquhnh5s2k6nqomltnbdjuhligflpyy6a"
    $token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($pat)"))
    $header = @{
        authorization = "Basic $token"
    }
    $url = "https://dev.azure.com/B4MService/Software%20Upgrading/_apis/testplan/plans/1/Suites/$id_type/TestPoint?api-version=7.0"
    Write-Host($url)
    Invoke-RestMethod -Method Get -Uri $url -Proxy "http://rb-proxy-sl.bosch.com:8080" -Headers $header -ContentType "application/json"
} -ArgumentList $id_type -Credential $Credential

$testpoint_list = ($testpoint_list_data | ConvertTo-Json -Depth 10) | ConvertFrom-Json
Write-Host($testpoint_list.value) 
