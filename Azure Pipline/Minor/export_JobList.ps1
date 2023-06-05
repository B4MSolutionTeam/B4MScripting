function export_Job_List($path)
{
    create_INI_file($path)
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\exportJobList.ini"
        
        
        $list_file = (Get-ChildItem -Path $path).Name
        
        if($list_file -contains "myJobList.csv")
        {
            $path_ComponentTypeXML = $path+"\myJobList.csv"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -lt 0)
            {
                Write-Host("Joblist file is null")
            }
            else
            {
                Write-Host("Joblist File export Success")
            }
        }
        else {
            Write-Host("Joblist file is exported")
        }
    
    }
    catch {
        Write-Host("Export JobList Fail")
    }
}
function create_INI_file
{
    param(
        $path
    )
    $INI_String = @"
    [Common]
    ReportType=JobList
    ExportFile=$path\myJobList.csv
    Dir=\
    [User]
    Account=BMT8HC
    Password=B4m013209112022@
    Domain=APAC
"@
    $INI_String | Out-File -FilePath ($path+"\exportJobList.ini")
}
$path = "D:\Test"
if(Test-Path -Path $path)
{
    export_Job_List($path)
}
else {
    New-Item -Path $path -ItemType Directory
    export_Job_List($path)
}