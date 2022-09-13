import datetime
from email.mime.text import MIMEText
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from email.mime.application import MIMEApplication
import json,os,subprocess



def send_mail_routine():
    SUBJECT = "[Automation] Check In, Check Out Testing"
    recipent = ["an.phamnhat@vn.bosch.com", "vu.nguyenhoanganh@vn.bosch.com"]
    msg = MIMEMultipart()
    msg['Subject'] = SUBJECT 
    msg['From'] = "Duy.TaThai@vn.bosch.com"
    msg['To'] = ", ".join(recipent)

    part = MIMEBase('application', "octet-stream")
    part.set_payload(open("D:/vdSA/report.csv", "rb").read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename="report.csv"')

    msg.attach(MIMEText("Dear all,\n We would like to report the status of status of Check In/Check Out Function:\n+ \tCheck Out status:","plain"))
    msg.attach(part)

    server = smtplib.SMTP("rb-smtp-int.bosch.com")
    server.sendmail("Duy.TaThai@vn.bosch.com",recipent, msg.as_string())

def send_mail_duplicate_version():
    # p = subprocess.check_output("powershell -file D:/vdSA/sendmail.ps1", shell = True)
    # print(p)   
    SUBJECT = "[Automation] Backup Version Overdate 10 year"
    recipent = ["an.phamnhat@vn.bosch.com"]
    msg = MIMEMultipart()
    msg['Subject'] = SUBJECT 
    msg['From'] = "Duy.TaThai@vn.bosch.com"
    msg['To'] = ", ".join(recipent)

    part = MIMEBase('application', "octet-stream")
    part.set_payload(open("D:/vdSA/report.csv", "rb").read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename="report.csv"')

    msg.attach(MIMEText("Hello, after examine all file backup version, we have discovered these files are overdate. Please kindly review and delete these files. Thank you", 'plain'))
    msg.attach(part)

    server = smtplib.SMTP("rb-smtp-int.bosch.com")
    server.sendmail("Duy.TaThai@vn.bosch.com","an.phamnhat@vn.bosch.com", msg.as_string())
    
def send_mail_total(SUBJECT ,MESSAGE, attachment_path):
    recipent = ["hc1_ci_b4m_operationproject@bcn.bosch.com"]
    msg = MIMEMultipart()
    msg['Subject'] = SUBJECT 
    msg['From'] = "Duy.TaThai@vn.bosch.com"
    msg['To'] = ", ".join(recipent)

    part = MIMEBase('application', "octet-stream")
    
    if len(attachment_path) > 0:
        for f in attachment_path:
            file_path = os.path.join("",f)
            print(file_path)
            attachment = MIMEApplication(open(file_path, "rb").read(), _subtype="csv")
            attachment.add_header('Content-Disposition','attachment', filename=(f.split("/"))[-1])
            msg.attach(attachment)
    msg.attach(MIMEText(MESSAGE, 'html'))
         
    # else:
    #     msg.attach(MIMEText(MESSAGE, 'plain'))

    server = smtplib.SMTP("rb-smtp-int.bosch.com")
    server.sendmail("Duy.TaThai@vn.bosch.com","hc1_ci_b4m_operationproject@bcn.bosch.com", msg.as_string())

    
list_file = list(os.listdir("D:/vdSA"))
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
    <p style="font-size:115%;color:#217cb4;">We would like to report from BA0VM153.de.bosch.com and BA0VM060.de.bosch.com </p>
""".format(style)
attachment_path = []
count_warning = 0
no_task = 1
if "report_1_153.json" in list_file or "report_1_060.json" in list_file :
    table = ""
    for file_report in ["report_1_153.json", "report_1_060.json"]:
        if file_report in list_file:
            report_1 = open("D:/vdSA/{}".format(file_report))
            data_1 = json.load(report_1)
            status_checkin = data_1["data"]["status"]["status_check_in"]
            status_checkout = data_1["data"]["status"]["status_check_out"]
            html_color_status_check_out = ""
            html_color_status_check_in = ""
            if "successfully" in status_checkin:
                html_color_status_check_in = "background-color: #96D4D4"
            elif "fail" in status_checkin:
                html_color_status_check_in = "background-color: #dd4848"
                count_warning = count_warning + 1
            elif "maintainance" in status_checkin:
                html_color_status_check_in = "background-color: #ffff00"
                count_warning = count_warning + 1
            elif "Database" in status_checkin:
                html_color_status_check_in = "background-color: #928f8f"
                count_warning = count_warning + 1
            elif "[no version backup created]" in status_checkin:
                html_color_status_check_in = "background-color: #ffff00"
                count_warning = count_warning + 1
                
            if "successfully" in status_checkout:
                html_color_status_check_out = "background-color: #96D4D4"  
            elif "fail" in status_checkout:
                html_color_status_check_out = "background-color: #dd4848" 
                count_warning = count_warning + 1 
            elif "maintainance" in status_checkout:
                html_color_status_check_out = "background-color: #ffff00"
                count_warning = count_warning + 1
            table = table + """
                    
                    <tr>
                        <td style="text-align:center; {};">{}</td>
                        <td style="text-align:center; {};">Check In</td>
                        <td style="text-align:center; {};">{}</td
                    </tr>
                    <tr>
                        <td style="text-align:center; {};">{}</td>
                        <td style="text-align:center; {};">Check Out</td>
                        <td style="text-align:center; {};">{}</td
                    </tr>
                    """.format( 
                                html_color_status_check_in,
                                data_1['data']['server'] + ".de.bosch.com",
                                html_color_status_check_in,
                                html_color_status_check_in,
                                status_checkin,
                                html_color_status_check_out,
                                data_1['data']['server'] + ".de.bosch.com",
                                html_color_status_check_out,
                                html_color_status_check_out,
                                status_checkout)
    
        
    message = message + """
    <p style="font-size:115%">{} - Routine Test Check In/Out Report </p>
    <table>
        <tr>
            <th style="color:#2b32c3;"><h3>Routine Test Check In/Out Report<h3></tr>
        </tr>
    </table>
    <table>
    <tr>
        <th style="color:#2b32c3;">Host</th>
        <th style="color:#2b32c3;">Service</th>
        <th style="color:#2b32c3;">Status</th>
    </tr>
    {}
    </table>
    """.format(no_task, 
            table)
    print(message)
    no_task = no_task + 1
    report_1.close()
    
if "report_2_153.json" in list_file or "report_2_060.json" in list_file:
    table = ""
    for file_report in ["report_2_153.json", "report_2_060.json"]:
        data_dump = subprocess.run(["powershell","-Command","Get-Content D:\\vdSA\\{} | ConvertFrom-Json".format(file_report)],capture_output=True)
        data_dump = str(data_dump.stdout)
        data_dump = data_dump[2:-5]
        data_dump = data_dump.replace("\\r","")
        data_dump = data_dump.replace("\\n","")
        data_dump = json.loads(data_dump)
        service_name = data_dump["data"]["service"]["service_name"]
        service_status = data_dump["data"]["service"]["service_status"]
        html_color_service = ""
        message_status = ""
        if service_status == "Stopped":
            html_color_service = "background-color: #dd4848"
            message_status = "*The service automatically restart, please review and take action if the service is not start again"
            count_warning = count_warning + 1
        elif service_status == "Running":
            html_color_service = "background-color: #96D4D4"
        table = table + """
        
        <tr>
            <td style="text-align:center; {};">{}</td>
            <td style="text-align:center; {};">{}</td>
            <td style="text-align:center; {};">{}</td
        </tr>
        """.format(html_color_service,
                    data_dump["data"]["server"] + ".de.bosch.com",
                    html_color_service, 
                    service_name, 
                    html_color_service, 
                    service_status)
    message = message + """
        <p style="font-size:115%">{} - vDog Checking/Recover Service Status </p>
        <table>
            <tr>
                <th style="color:#2b32c3;"><h3>vDog Checking/Recover Service Status<h3></tr>
            </tr>
        </table>
        <table>
        <tr>
            <th style="color:#2b32c3;">Host</th>
            <th style="color:#2b32c3;">Service</th>
            <th style="color:#2b32c3;">Status</th>
        </tr>
        {}
        </table>
        <p style="font-size:115%;">{}</p>""".format(no_task,
                                                  table,
                                                  message_status)
    no_task = no_task + 1    

if "report_3_153.json" in list_file or "report_3_060.json" in list_file:
    data_table = ""
    check_no_file_report = ""
    count_no_file_report = 0
    check_attachment = ""
    for list_report in ["report_3_153.json", "report_3_060.json"]:
        if list_report in list_file:
            report_3 = open("D:/vdSA/{}".format(list_report))
            data_3 = json.load(report_3)    
            num_file = int(data_3['data']['num'])    
            if num_file > 0:
                count_warning = count_warning +1
                if num_file > 10:
                    check_attachment = " ( Please check attachments )"
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
                        attachment_path.append("D:/vdSA/report_153.csv")
                    elif list_report == "report_3_060.json":
                        attachment_path.append("D:/vdSA/report_060.csv")
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
            <p style="font-size:115%">*There is no backup version overdate of {}</p>""".format("BA0VM"+((list_report.split("_"))[2])[0:3]+".de.bosch.com")
    if count_no_file_report < len(["153","060"]):
        message = message + """<p style="font-size:115%">{} - Backup Version Overdate Report {}</p>
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
            """.format(no_task,check_attachment,check_no_file_report,data_table)
    no_task = no_task + 1
    report_3.close()       
else:
    message = message + """
            <p style="font-size:115%">{} - Backup Version Overdate Report</p>
            <p style="font-size:115%">There is no backup version overdate of BA0VM153.de.bosch.com and BA0VM060.de.bosch.com</p>
            """.format(no_task) 
message = message + """
    <p style="font-size:115%;color:#217cb4;">Best Regard,</p>
    <p style="font-size:115%;color:#217cb4;">B4M Operation Team</p>
</body>
</html>"""
print(message)


send_mail_total("[{} Warning] vDog Service Report {}".format(count_warning,(datetime.date.today()).strftime("%d/%m/%Y")),message, attachment_path)