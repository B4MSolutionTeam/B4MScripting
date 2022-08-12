from datetime import datetime
from email.mime.text import MIMEText
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
import json,os

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
    part.set_payload(open("C:/vdSA/report.csv", "rb").read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename="report.csv"')

    msg.attach(MIMEText("Hello, after examine all file backup version, we have discovered these files are overdate. Please kindly review and delete these files. Thank you", 'plain'))
    msg.attach(part)

    server = smtplib.SMTP("rb-smtp-int.bosch.com")
    server.sendmail("Duy.TaThai@vn.bosch.com","an.phamnhat@vn.bosch.com", msg.as_string())
    
def send_mail_total(MESSAGE, attachment_path):
    SUBJECT = "Report for B4M Automation Task"
    recipent = ["an.phamnhat@vn.bosch.com"]
    msg = MIMEMultipart()
    msg['Subject'] = SUBJECT 
    msg['From'] = "Duy.TaThai@vn.bosch.com"
    msg['To'] = ", ".join(recipent)

    part = MIMEBase('application', "octet-stream")
    if len(attachment_path) > 0:
        part.set_payload(open(attachment_path, "rb").read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="report.csv"')
        msg.attach(part)
    msg.attach(MIMEText(MESSAGE, 'plain'))
    

    server = smtplib.SMTP("rb-smtp-int.bosch.com")
    server.sendmail("Duy.TaThai@vn.bosch.com","an.phamnhat@vn.bosch.com", msg.as_string())

    
list_file_report = ["report_duplicate_version.json", "report_routine.json", "report.csv"]
message = "Dear Team,\n Report of B4M Automation Task in %:".format(str(datetime.date.today()))

attachment_path = ""


for i in os.listdir("C:/vdSA"):
    if "report_duplicate_version.json" in i:
        f = open("C:/vdSA/report_duplicate_version.json")
        data = json.load(f)
        num_file = data["data"]["num"]
        message = message + "\nReport from the [Automation] Backup Version Overdate problem:\n\t +Number of version of each component is/are overdate: %\nPlease see detail in the attachment 'report.csv'".format(num_file)
        attachment_path = "C:/vdSA/report.csv"
    