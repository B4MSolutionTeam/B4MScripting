$ie = New-Object -com InternetExplorer.Application
$ie.visible = $true
$ie.top = 0 ; $ie.width = 3840; $ie.height = 2160; $ie.left = 0
$ie.resizable = $true
$list_server = Get-Content -Path "D:\Automation_Task\duy.txt"
foreach($server in $list_server)
{
    $url = 'https://rb-itoa-splunk-reporting.de.bosch.com/en-US/app/ITOA-Reporting/system_utilization?form.server2=*&form.Time.earliest=-24h%40h&form.Time.latest=now&form.span=15m&form.reApp=*&form.server='+$server
    $ie.navigate($url)
    #$ie.fullscreen = $true
    While ($ie.Busy) {  
        Start-Sleep 20
    }
    
    Start-Sleep 5
    $naming = ((([string]$server).Split("."))[0])
    $ie.Document.getElementById('panel1').innerHTML > "D:\Automation_Task_Report_File\CPU_$naming.html"
    $ie.Document.getElementById('panel2').innerHTML > "D:\Automation_Task_Report_File\Physical_RAM_$naming.html"
    $ie.Document.getElementById('panel3').innerHTML > "D:\Automation_Task_Report_File\Virtual_RAM_$naming.html"
    $ie.Document.getElementById('panel5').innerHTML > "D:\Automation_Task_Report_File\Disk_$naming.html"
}

$ie.quit()

$list_html = (Get-ChildItem -Path "D:\Automation_Task_Report_File" | Where-Object {$_.Extension -in ".html"})
foreach($html_file in $list_html)
{
    D:\Automation_Task\Chrome\Application\chrome.exe --headless --screenshot="D:\Automation_Task_Report_File\report_5_$((([string]$html_file).Split("."))[0]).png" --window-size=1053,332 "D:\Automation_Task_Report_File\$([string]$html_file)"
}
