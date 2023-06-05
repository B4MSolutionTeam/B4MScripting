Clear-Host
Write-Host '##########################################'
$servicename = "VDog MasterService"
$serviceinfo = @{}
$servicestatus = ""
$get_date = Get-Date -UFormat "%d/%m/%Y"

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

    $json_report_file = @{data=@{}}
    $json_report_file["data"].Add("function", "[Automation] Check vDog Service")
    $json_report_file["data"].Add("time", "$get_date")
    $json_report_file["data"].Add("server", "$([System.Net.Dns]::GetHostName())")
    $service = @{}
    $service.Add("service_name", "$servicename")
    $service.Add("service_status", "$check_service_status_return")
    $json_report_file["data"].Add("service",$service)
    
    $path_json = "D:\Automation_Task_Report_File\report_2_061.json"
    if ((Test-Path -Path $path_json -PathType Leaf) -eq $false)
    {
        $json_report_file | ConvertTo-Json | Out-File $path_json
        # Get-Content C:\vdSA\servicename_report.json | ConvertFrom-Json
    }
    else 
    {
        Remove-Item -Path $path_json
        $json_report_file | ConvertTo-Json | Out-File $path_json
        $test = Get-Content -Path $path_json
        Write-Host $test
    }
}

create_report_file
