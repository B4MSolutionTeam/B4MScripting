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

$path_bulk = "\\ba00fb02-sl4.de.bosch.com\B4M\Automation\Automation_Script_Report_File"

function Copy_To_Bulk
{
    param(
        $path_json, $path_bulk
    )
    . "D:\B4M\Automation\Script_Automation\get_pam_password.ps1"

    $password = Get-PAMPassword
    net use $path_bulk /u:APAC\BMT8HC $password
    Copy-Item -Path $path_json -Destination $path_bulk
    net use $path_bulk /delete
}
function create_report_file()
{
    $check_service_status_return = check_service_start($servicename)

    $json_report_file = @{data=@{}}
    $json_report_file["data"].Add("function","[Automation] Check vDog Service")
    $json_report_file["data"].Add("time","$get_date")
    $json_report_file["data"].Add("server", "$([System.Net.Dns]::GetHostName())")
    $service = @{}
    $service.Add("service_name", "$servicename")
    $service.Add("service_status", "$check_service_status_return")
    $json_report_file["data"].Add("service",$service)

    $path_json = "D:\B4M\Automation\Report_File\report_2_$([System.Net.Dns]::GetHostName()).json"
    
    if ((Test-Path -Path $path_json -PathType Leaf) -eq $false)
    {
        $json_report_file | ConvertTo-Json | Out-File $path_json
        # Get-Content C:\vdSA\servicename_report.json | ConvertFrom-Json
    }
    else 
    {
        Remove-Item -Path $path_json
        $json_report_file | ConvertTo-Json | Out-File $path_json
        $test = Get-Content $path_json
        Write-Host $test
    }
    Copy_To_Bulk -path_json $path_json -path_bulk $path_bulk
}

create_report_file
