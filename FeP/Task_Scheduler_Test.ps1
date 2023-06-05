function get_status_service($service_name)
{
    if(Get-Service($service_name))
    {
        $serviceinfo = Get-Service -name $service_name
        $servicestatus = $serviceinfo.Status
        if ($serviceinfo.Status -eq "Stopped")
        {
            Start-Service -name $service_name
            Write-Host "Service Start"
            if ((Get-Service $service_name).StartType -eq "Automatic")
            {
                Start-Service -name $service_name
                Write-Host "$service_name"
            }
        }
        else
        {
            Write-Host "Service $service_name is $servicestatus"
        }
        return $servicestatus
    }
    else {
        return "$service_name is not exist "
    }
}

function create_report_file($service_name)
{
    $service_status = Get_Status_Service($service_name)
    $get_date = Get-Date
    $server_name = [System.Net.Dns]::GetHostName()
    $json_report_file = @"
    {
        "data":{
            "function": "[Automation] Check vDog Service",
            "time": "$get_date",
            "exist": "True",
            "server": "$server_name",
            "service":{
                "service_name": "$service_name",
                "service_status": "$service_status"
            }
        }
    }
"@
    if(Test-Path -Path "C:\vdSA\Report_Daily" -IsValid)
    {
        $json_report_file | ConvertTo-Json | Out-File "\report_2_$server_name.json"
    }
    else
    {
        New-Item -Path "C:\" -Name "Report_Daily" -ItemType Directory
        $json_report_file | ConvertTo-Json | Out-File "\report_2_$server_name.json"
    }
    
}

$scheduleObject = New-Object -ComObject schedule.service
$scheduleObject.connect()
$root= $scheduleObject.GetFolder("\")
$subfolder  = $root.GetFolders(0)
$temp_list_folder = @()
foreach($folder in $subfolder)
{
    $folder_name = [string]($folder.Name)
    $temp_list_folder += $folder_name
}
if("Automation Task" -in $temp_list_folder)
{
    Write-Host("Have folder")
    $list_task_schedule = (Get-ScheduledTask).TaskName
    if("Powershell_Test" -in $list_task_schedule)
    {
        $service_name = "XblAuthManager"
        create_report_file($service_name)
    }
    else
    {
        SCHTASKS /CREATE /SC DAILY /TN "\Automation Task\Powershell_Test" /TR "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /ST 11:00 /RU "APAC\TAD6HC"
        $service_name = "XblAuthManager"
        create_report_file($service_name)
    }
}
else
{
    Write-Host("Dont Have folder")
    $scheduleObject = New-Object -ComObject schedule.service
    $scheduleObject.connect()
    $rootFolder = $scheduleObject.GetFolder("\")
    $rootFolder.CreateFolder("Automation Task")

    $list_task_schedule = (Get-ScheduledTask).TaskName
    if("Powershell_Test" -in $list_task_schedule)
    {
        $service_name = "XblAuthManager"
        create_report_file($service_name)
    }
    else
    {
        SCHTASKS /CREATE /SC DAILY /TN "\Automation Task\Powershell_Test" /TR "C:\Windows\System32\WindowsPowerShell\v1.0\powershell_ise.exe" /ST 11:00 /RU "APAC\TAD6HC"
        $service_name = "XblAuthManager"
        create_report_file($service_name)
    }
}
