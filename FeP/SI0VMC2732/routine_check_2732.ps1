function check_in_function
{
    param(
        $password_string
    )
    
    try
    {
        $ini_file = "D:\Automation_Task_Script\AutoCheckIn.ini"
        $status_checkin = C:\TEF\vdogClient\VDogAutoCheckIn.exe /rd:d:\vdCA /AT:C /CFile:$ini_file /Account:bmt8hc /Domain:APAC /Password:$password_string
        if($status_checkin.Length -eq 0)
        {
            return "Check In successfully"
        }
        elseif($status_checkin.Length -gt 0)
        {
            $errorText = ""
            $ini_content = Get-Content -Path $ini_file
            if ($ini_content -contains "[Result]")
            {
                $ini_temp = @()
                $errorText = (($ini_content[-2]).Split("="))[-1]
                foreach($line in $ini_content)
                {
                    if($line -eq "[Result]")
                    {
                        break
                    }
                    else {
                        $ini_temp += $line
                    }
                }
                $ini_temp | Out-File -FilePath $ini_file
            }
            return "ERR: "+ $errorText
        }
    }catch [System.Exception]
    {
        return "vDog server is in maintainance, can't proceed this process"
    }
    
}
function check_out_function
{
    param(
        $password_string
    )
    try {
        $status_checkout = C:\TEF\vdogClient\VDogAutoCheckOut.exe /rd:d:\vdCA /AT:C /dirR:\TestArea-FeP\B4M_tad6hc\XML_Test \CID:A2D95CCB7AA14602B034171B6842D3B9 /Account:bmt8hc /Domain:APAC /Password:$password_string
        Write-Host($status_checkout)
        if(($status_checkout.Split())[0] -eq "INF")
        {
            return "Check Out successfully"
        }
        elseif(($status_checkout.Split())[0] -eq "ERR")
        {
            return "$status_checkout"
        }
        
    }
    catch [System.Exception]{
        return "vDog server is in maintainance, can't proceed this process"
    }
   
}

function create_json_report 
{

    $password = "B4m013209112022@"
    $status_return_checkin = check_in_function $password
    $status_return_checkout = check_out_function $password

    $data_json = @{data = @{}}
    $data_json["data"].Add("function","[Automation] Routine Check In/Check Out")
    $data_json["data"].Add("time", "$(Get-Date -UFormat "%d/%m/%Y")")
    $data_json["data"].Add("exist", "True")
    $data_json["data"].Add("server", "$([System.Net.Dns]::GetHostName())")
    $status = @{

    }
    $status.Add("status_check_in", "$status_return_checkin")
    $status.Add("status_check_out", "$status_return_checkout")
    $data_json["data"].Add("status",$status)

    $path_json = "D:\Automation_Task_Report_File\report_1_2732.json"

    if(Test-Path -Path $path_json)
    {
        Remove-Item -Path $path_json
        $data_json | ConvertTo-Json | Out-File $path_json
    }
    else {
        
        $data_json | ConvertTo-Json | Out-File $path_json
    }
}
create_json_report