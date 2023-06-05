
$path_folder = "$(Path_Azure_Test)"
$User = "apac\bmt8hc"
$PWord = ConvertTo-SecureString -String "B4m013209112022@" -AsPlainText -Force
$Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $user, $PWord
$status_update = "passed"
function export_Project_Tree
{
    param (
        $path
    )
    $path_a = $path
    Invoke-Command -ScriptBlock {
        function create_INI_file 
{
    param (
        $path
    )
    $ini_file = @"
    [Common]
    ReportType=ComponentTree
    ExportFile=$path\myComponentTree.xml
    WithVersions=Y
    WithMasterData=Y
    EnableNodeTree=N
    Dir=\Ba
    [User]
    Account=BMT8HC
    Password=B4m013209112022@
    Domain=APAC
"@
    $ini_file | Out-File -FilePath "$path\exportComponentTree.ini"
}
    create_INI_file $path_a
    }

    
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:$path\exportComponentTree.ini"
        
        
        $list_file = (Get-ChildItem -Path $path).Name
        
        if($list_file -contains "myComponentTree.xml")
        {
            $path_ComponentTypeXML = $path+"\myComponentTree.xml"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -le 0)
            {
                Write-Host("Project Tree file is null")
                $status_update = "failed"
            }
            else
            {
                Write-Host("Export Project Tree success")
                $status_update = "passed"
            }
        }
        else {
            Write-Host("No Project Tree file is exported")
            $status_update = "failed"
        }
    
    }
    catch {
        Write-Host("Export Component Tree Fail")
        $status_update = "failed"
    }
}

Invoke-Command -ComputerName "BA0VM153.de.bosch.com" -ScriptBlock ${Function:export_Project_Tree} -ArgumentList $path_folder -Credential $Credential
$pat = "e3x5b6ler2dksl44o7dgquhnh5s2k6nqomltnbdjuhligflpyy6a"
$token = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes(":$($pat)"))
$header = @{
    authorization = "Basic $token"
}
$url = "https://dev.azure.com/B4MService/Software%20Upgrading/_apis/testplan/plans/1/Suites/101/TestPoint?api-version=7.0"

$body = @"
[{
    "id": $(S_Exporting_Project_Tree_ID),
    "results": {
    "outcome": "$status_update"
    }
}]
"@
Write-Host "ID: $(S_Exporting_Project_Tree_ID)"
Invoke-RestMethod -Method Patch -Uri $url -Proxy "http://rb-proxy-sl.bosch.com:8080" -Headers $header -Body $body -ContentType "application/json"