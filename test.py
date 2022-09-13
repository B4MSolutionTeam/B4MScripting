from colorsys import hsv_to_rgb
import json
import os
import subprocess
# for i in os.listdir("C:/vdServerArchive"):
#     print(i)
list_file = list(os.listdir("C:/vdServerArchive"))
print(list_file)
style = """<style>
            table, th, td {
                border: 1px solid black;
                width: 1920px;
                font-size: 110%
            }
            th, td{
                background-color: #96D4D4
            }
            </style>"""
message = """<html>
    <head>
        {}
    </head>
<body>
    <p style="font-size:115%;color:#217cb4;">Dear Team,</p>
    <p style="font-size:115%;color:#217cb4;">We would like to report Automation Task of B4M (Backup for Manufactoring) Project, please review and take action if neccessary. Thank you ! </p>
""".format(style)
no_task = 1
count_warning = 0
attachment_path = []
if "report_3_153.json" in list_file or "report_3_060.json" in list_file:
    data_table = ""
    check_no_file_report = ""
    count_no_file_report = 0
    for list_report in ["report_3_153.json", "report_3_060.json"]:
        if list_report in list_file:
            report_3 = open("C:/vdServerArchive/{}".format(list_report))
            data_3 = json.load(report_3)    
            num_file = int(data_3['data']['num'])    
            if num_file > 0:
                count_warning = count_warning +1
                if num_file > 10:
                    host_name = "BA0VM"+((list_report.split("_"))[2])[0:3]+"de.bosch.com"
                    for attribute_file in (data_3["data"]["overdate_version"])[0:10]:
                        data_table = data_table +  """
                        <tr>
                            <td style="text-align:center">{}</td>
                            <td style="text-align:center">{}</td>
                            <td style="text-align:center">{}</td>
                            <td style="text-align:center">{}</td>
                        </tr>
                        """.format(host_name,
                                attribute_file["factory_name"],
                                (attribute_file["path"]).replace("/","\\"),
                                attribute_file["create_date"])
                    if list_report == "report_3_153.json":
                        attachment_path.append("C:/vdServerArchive/report_153.csv")
                    elif list_report == "report_3_060.json":
                        attachment_path.append("C:/vdServerArchive/report_060.csv")
                else:
                    for attribute_file in (data_3["data"]["overdate_version"])[0:10]:
                        data_table = data_table +  """
                        <tr>
                            <td style="text-align:center">{}</td>
                            <td style="text-align:center">{}</td>
                            <td style="text-align:center">{}</td>
                        </tr>
                        """.format(attribute_file["factory_name"],
                                (attribute_file["path"]).replace("/","\\"),
                                attribute_file["create_date"])
        else:
            count_no_file_report = count_no_file_report + 1
            check_no_file_report = """
            <p style="font-size:115%">There is no backup version overdate of {}</p>""".format("BA0VM"+((list_report.split("_"))[2])[0:3]+".de.bosch.com")
    if count_no_file_report < len(["153","060"]):
        message = message + """<p style="font-size:115%">{} - Backup Version Overdate Report</p>
            {}
            <table>
                <tr>
                    <th style="color:#2b32c3;"><h3>Backup Version Overdate Report<h3></th>
                </tr>
            </table>
            <table>
                <tr>
                    <th style="color:#2b32c3;">Host</th>
                    <th style="color:#2b32c3;">Plant</th>
                    <th style="color:#2b32c3;">Path</th>
                    <th style="color:#2b32c3;">Create Date</th>
                </tr>
                
                {}
            </table>
            """.format(no_task,check_no_file_report,data_table)
    no_task = no_task + 1
    report_3.close()       
else:
    message = message + """
            <p style="font-size:115%">{} - Backup Version Overdate Report</p>
            <p style="font-size:115%">There is no backup version overdate of BA0VM153.de.bosch.com and BA0VM060.de.bosch.com</p>
            """.format(no_task)        
print(message)
print(attachment_path) 