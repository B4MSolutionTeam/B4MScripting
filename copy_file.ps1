Copy-Item "\\BA0VM060\vdServerArchive\Report_Daily\report_1_060.json" -Destination "D:\vdSA\Report_Daily"
Copy-Item "\\BA0VM060\vdServerArchive\Report_Daily\report_2_060.json" -Destination "D:\vdSA\Report_Daily"
Copy-Item "\\BA0VM060\vdServerArchive\Report_Daily\Disk_Utilization_BA0VM060.de.bosch.com.json" -Destination "D:\vdSA\Report_Daily"

Copy-Item "\\BA0VM061\Report_Daily\report_1_061.json" -Destination "D:\vdSA\Report_Daily"
Copy-Item "\\BA0VM061\Report_Daily\report_2_061.json" -Destination "D:\vdSA\Report_Daily"
Copy-Item "\\ba0vm061.de.bosch.com\Report_Daily\Disk_Utilization_BA0VM061.de.bosch.com.json" -Destination "D:\vdSA\Report_Daily"

Copy-Item "\\ba0vm00246.de.bosch.com\Report_Daily\Disk_Utilization_BA0VM00246.de.bosch.com.json" -Destination "D:\vdSA\Report_Daily"

Start-Sleep 10
Remove-Item -Path \\BA0VM060\vdServerArchive\Report_Daily\Disk_Utilization_BA0VM060.de.bosch.com.json
Remove-Item -Path \\BA0VM060\vdServerArchive\Report_Daily\report_1_060.json
Remove-Item -Path \\BA0VM060\vdServerArchive\Report_Daily\report_2_060.json

Remove-Item -Path \\ba0vm061.de.bosch.com\Report_Daily\Disk_Utilization_BA0VM061.de.bosch.com.json
Remove-Item -Path \\BA0VM061.de.bosch.com\Report_Daily\report_1_061.json

Remove-Item -Path \\ba0vm00246.de.bosch.com\Report_Daily\Disk_Utilization_BA0VM00246.de.bosch.com.json