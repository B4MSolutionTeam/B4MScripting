Clear-Host
Write-Host '##########################################'
$servicename = "VDog MasterService"
$serviceinfo = @{}
$servicestatus = ""
$get_date = Get-Date -UFormat "%d/%m/%Y"

function check_service_start()
{
    param(
        $service_name
    )
    
    if (Get-Service $service_name -ErrorAction SilentlyContinue)
    {
        Write-Host "$service_name exists"
        $serviceinfo = Get-service -name $service_name
        $servicestatus = $serviceinfo.Status
        if ($serviceinfo.Status -eq "Stopped")
        {
            Start-Service -name $service_name
            Write-Host "Service Start"
            # Write-Host "Service $servicename is $servicestatus"
            if ((Get-Service $service_name).StartType -eq "Automatic")
            {
                Start-Service -name $service_name
                Write-Host "$service_name"
                #Write to DB the information (at next version)
            }
        }
        else
        {
            Write-Host "Service $service_name is $servicestatus"
        }
    }
    else
    {
        Write-Host "$service_name dose not exists"
        #Write to DB the information (At next version)
    }
    Write-Host '##########################################'
    return $servicestatus
}

function create_report_file()
{
    param(
        $service_name
    )
    $check_service_status_return = check_service_start -service_name $service_name

    $json_report_file = @{data=@{}}
    $json_report_file["data"].Add("function","[Automation] Check vDog Service")
    $json_report_file["data"].Add("time","$get_date")
    $json_report_file["data"].Add("server", "$([System.Net.Dns]::GetHostName())")
    $service = @{}
    $service.Add("service_name", "$service_name")
    $service.Add("service_status", "$check_service_status_return")
    $json_report_file["data"].Add("service",$service)

    $path_json = "D:\Automation_Task_Report_File\report_2_03418.json"

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

create_report_file -service_name $servicename