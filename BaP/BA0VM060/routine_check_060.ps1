

function check_out_function($password_String)
{
    try {
        $status_return = C:\Users\TAD6HC\Desktop\vdClient\VDogAutoCheckOut.exe /rd:D:\vdogData /at:c /dirR:\Training\test_duy\ASCII3 /CID:2B343B5729FE4286A0FD4ACAD7DB1F0E /Password:$password_string /Account:bmt8hc /Domain:apac
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
function check_in_function($password_String)
{
    
    try {
        $status_return = C:\Users\TAD6HC\Desktop\vdClient\VDogAutoCheckIn.exe /RD:D:\vdogData /AT:C /CFile:D:\Automation_Script\AutoCheckIn.ini /Password:$password_string /Account:bmt8hc /Domain:apac
        
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
    catch {
        return "vDog server is in maintainance, can't proceed this process"
    }
}

function create_json_report()
{
    param(
        $password_String
    )
    $status_check_in = check_in_function($password_String)
    $status_check_out = check_out_function($password_String)
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
    
    $path_json = "D:\Automation_Script_Report_File\report_1_060.json"
    if(Test-Path -Path $path_json)
    {
        Remove-Item -Path $path_json
        $data_json | ConvertTo-Json | Out-File $path_json
    }
    else {
        
        $data_json | ConvertTo-Json | Out-File $path_json
    }
    
}
. "D:\Automation_Script\get_pam_password.ps1"
$password_pam = Get-PAMPassword
create_json_report -password_String $password_pam


