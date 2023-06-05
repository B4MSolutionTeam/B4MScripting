

function export_Job_Result_Difference($path)
{
    create_INI_file($path)
    try {
        D:\vdogClient\VDogAutoExport.exe "/rd:D:\vdCA" "/CFile:D:\Test\exportJobResultDifference.ini"
        
        
        $list_file = (Get-ChildItem -Path $path).Name
        
        if($list_file -contains "myJobReportDifference.csv")
        {
            $path_ComponentTypeXML = $path+"\myJobReportDifference.csv"
            $size_ComponentTypeXML = (Get-Item -Path $path_ComponentTypeXML).Length
            if($size_ComponentTypeXML -lt 0)
            {
                Write-Host("myJobReportDifference.csv file is null")
            }
        }
        else {
            Write-Host("No myJobReportDifference.csv file is exported")
        }
    
    }
    catch {
        Write-Host("Export Job Result Diffrenent Function Fail")
    }
}

function create_INI_file($path)
{
    $ini_file = @"
    [Common]
    ReportType=UnequalJobResults
    ExportFile=D:\Test\myJobReportDifference.csv
    Dir=\
     
    [User]
    Account=tad6hc
    Password=Haha050399@@@
    Domain=APAC
"@
    if (Test-Path -Path ($path+"\exportJobResultDifference.ini"))
    {
        $ini_file | Out-File -FilePath ($path+"\exportJobResultDifference.ini")
    }
    else
    {
        $ini_file | Out-File -FilePath ($path+"\exportJobResultDifference.ini")
    }
    
}

$path_folder = "D:\Test"
if(Test-Path -Path $path_folder)
{
    export_Job_Result_Difference($path_folder)
}
else
{
    New-Item -Path $path_folder -ItemType Directory
    export_Job_Result_Difference
}
