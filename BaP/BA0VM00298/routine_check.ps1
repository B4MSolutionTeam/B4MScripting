function check_out_function($password_string)
{
    try {
        
        $status_return = D:\B4M\ClientProfile\BMT8HC\vdogClient\VDogAutoCheckOut.exe /RD:D:\B4M\CA /at:c /dirR:\Training\test_duy\ASCII3 /CID:2B343B5729FE4286A0FD4ACAD7DB1F0E /Account:bmt8hc /Password:$password_string /Domain:APAC
        # Write-Host($status_return)
        $list_char_status = $status_return.Split(" ")
        if($list_char_status -contains "INF")
        {
            return "Check Out successfully"
        }
        else
        {
            return "Check Out fail."
        }
    }
    catch [System.Exception]{
        return "vDog server is in maintainance, can't proceed this process" 
    }
    
}
function check_in_function($password_string)
{   
    try {
        $status_return =  D:\B4M\ClientProfile\BMT8HC\vdogClient\VDogAutoCheckIn.exe /RD:D:\B4M\CA /AT:C /CFile:D:\B4M\Automation\Script_Automation\AutoCheckIn.ini /Password:$password_string /Account:bmt8hc /Domain:apac
        
        if($status_return.Length -eq 0)
        {
            return "Check In successfully"
        }
        elseif ($status_return.Length -ne 0) {
            if($status_return -contains "ERR SQLException")
            {
                return "Database is probaly already opened by another engine in another Window session, can't proceed this process"
            }
            elseif ($status_return -contains "[22313]") {
                return "There is no backup version created"
            } 
            else {
                return "Check In proceed fail"
            }
        } 
    }
    catch [System.Exception]{
        return "vDog server is in maintainance, can't proceed this process"
    }
}

$path_bulk = "\\ba00fb02-sl4.de.bosch.com\B4M\Automation\Automation_Script_Report_File"
function Copy_To_Bulk
{
    param(
        $path_json, $path_bulk, $password
    )
    
    net use $path_bulk /u:APAC\BMT8HC $password
    Copy-Item -Path $path_json -Destination $path_bulk
    net use $path_bulk /delete
}

function create_json_report()
{
    . "D:\B4M\Automation\Script_Automation\get_pam_password.ps1"

    $password = Get-PAMPassword
    $status_check_in = check_in_function($password)
    $status_check_out = check_out_function($password)
    $data_json = @{data = @{}}
    $data_json["data"].Add("function","[Automation] Routine Check In/Check Out")    
    $data_json["data"].Add("time", "$(Get-Date -UFormat "%d/%m/%Y")")
    $data_json["data"].Add("exist", "True")
    $data_json["data"].Add("server", "$([System.Net.Dns]::GetHostName())")
    $status = @{

    }
    $status.Add("status_check_in", "$status_check_in")
    $status.Add("status_check_out", "$status_check_out")
    $data_json["data"].Add("status",$status)

    $path_json = "D:\B4M\Automation\Report_File\report_1_$([System.Net.Dns]::GetHostName()).json"

    if(Test-Path -Path $path_json)
    {
        Remove-Item -Path $path_json
        $data_json | ConvertTo-Json | Out-File $path_json
    }
    else {
        
        $data_json | ConvertTo-Json | Out-File $path_json
    }

    Copy_To_Bulk -path_json $path_json -path_bulk $path_bulk -password $password

}


create_json_report