Clear-Host
Write-Host '##########################################'
$servicename = "VDog MasterService"
$serviceinfo = @{}
$servicestatus = ""
$get_date = Get-Date -UFormat "%d/%m/%Y"

# function Get-PAMPassword ($userid) {   
#     $uid = $($userid -replace ".*\\").Trim()
#     $url = "https://rb-pam-aim.bosch.com/aimwebservice/api/Accounts?AppID=CCP_ITM_ba&Safe=ITM_applications_ba&UserName=$uid"
#     $result = Invoke-WebRequest -Uri $url -Method GET -ContentType "application/json" -UseBasicParsing #, Enable this flag only running in versiondog
#     $password = ConvertFrom-Json $result.Content
#     return $password.Content.Trim('"')  
# }


function check_service_start($servicename)
{
    
    if (Get-Service $servicename -ErrorAction SilentlyContinue)
    {
        Write-Host "$servicename exists"
        $serviceinfo = Get-service -name $servicename
        $servicestatus = $serviceinfo.Status
        if ($serviceinfo.Status -eq "Stopped")
        {
            Start-Service -name $servicename
            Write-Host "Service Start"
            # Write-Host "Service $servicename is $servicestatus"
            if ((Get-Service $servicename).StartType -eq "Automatic")
            {
                Start-Service -name $servicename
                Write-Host "$servicename"
                #Write to DB the information (at next version)
            }
        }
        else
        {
            Write-Host "Service $servicename is $servicestatus"
        }
    }
    else
    {
        Write-Host "$servicename dose not exists"
        #Write to DB the information (At next version)
    }
    Write-Host '##########################################'
    return $servicestatus
}
function create_report_file()
{
    $check_service_status_return = check_service_start($servicename)

    $json_report_file = @"
{
    "data":{
        "function": "[Automation] Check vDog Service",
        "time": "$get_date",
        "exist": "True",
        "server": "BA0VM153",
        "service":{
            "service_name": "$servicename",
            "service_status": "$check_service_status_return"
        }
    }
}
"@
    if ((Test-Path -Path "D:\vdSA\report_2_153.json" -PathType Leaf) -eq $false)
    {
        $json_report_file | ConvertTo-Json | Out-File "D:\vdSA\report_2_153.json"
        # Get-Content C:\vdSA\servicename_report.json | ConvertFrom-Json
    }
    else 
    {
        Remove-Item -Path "D:\vdSA\report_2_060.json"
        $json_report_file | ConvertTo-Json | Out-File "D:\vdSA\report_2_153.json"
        $test = Get-Content "D:\vdSA\report_2_153.json"
        Write-Host $test
    }
}

create_report_file
#Start-Process powershell D:\vdSA\check_service.ps1 -Verb runAs