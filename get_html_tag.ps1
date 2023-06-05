$ie = New-Object -com InternetExplorer.Application
$ie.visible = $true
$ie.top = 0 ; $ie.width = 3840; $ie.height = 2160; $ie.left = 0
$ie.resizable = $true
$url = 'https://rb-itoa-splunk-reporting.de.bosch.com/en-US/app/ITOA-Reporting/system_utilization?form.server2=*&form.Time.earliest=-24h%40h&form.Time.latest=now&form.span=15m&form.reApp=*&form.server=ba0vm060.de.bosch.com&form.server=ba0vm061.de.bosch.com&form.server=ba0vm153.de.bosch.com&form.server=BA0VM00246.de.bosch.com'
$ie.navigate($url)
#$ie.fullscreen = $true
While ($ie.Busy) {  
    Start-Sleep 20
}
Start-Sleep 10
$ie.Document.getElementById('panel1').innerHTML > "D:\Automation_Task\CPU.html"
$ie.Document.getElementById('panel2').innerHTML > "D:\Automation_Task\Physical_RAM.html"
$ie.Document.getElementById('panel3').innerHTML > "D:\Automation_Task\Virtual_RAM.html"
$ie.Document.getElementById('panel5').innerHTML > "D:\Automation_Task\Disk.html"
 
# Start-Sleep 10
# Copy-Item "D:\Report_Daily\CPU.html" 
# Copy-Item "D:\Report_Daily\Physical_RAM.html" 
# Copy-Item "D:\Report_Daily\Virtual_RAM.html" 
# Copy-Item "D:\Report_Daily\Disk.html"

# Start-Sleep 10

# Remove-Item -Path D:\Report_Daily\CPU.html
# Remove-Item -Path D:\Report_Daily\Physical_RAM.html
# Remove-Item -Path D:\Report_Daily\Virtual_RAM.html
# Remove-Item -Path D:\Report_Daily\Disk.html
$ie.quit()