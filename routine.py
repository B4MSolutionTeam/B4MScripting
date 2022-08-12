
import subprocess
# import ctypes
import smtplib
import datetime
from email.mime.text import MIMEText
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
import json


def check_out_function():
    cmdlet_check_out = "D:" + '\\'+"vdClient\VDogAutoCheckOut.exe" + ' /' +"rd:d:"+ '\\' + "vdCA /at:c /dirR:\Ba\HDEV6" + '\\' + "test\Json /CID:C7EDE92A798B44CFA496048CFB87A132 /Account:Versiondog /Password:changeit"
    print(cmdlet_check_out)
    check_out = (subprocess.check_output(cmdlet_check_out, shell=True)).decode("utf-8")
    if "INF" in check_out.split(" ")[0]:
        # ctypes.windll.user32.MessageBoxW(0, u"Check out function proceed successfully", u"Success", 0)
        return "VDogAutoCheckOut.exe proceed successfully"
    else:
        # ctypes.windll.user32.MessageBoxW(0, check_out, u"Error", 0)
        return "VDogAutoCheckOut.exe proceed fail."
        
def check_in_fucntion():
    cmdlet_check_in = "D:" + '\\'+"vdClient\VDogAutoCheckIn.exe" + " /RD:D:" + '\\' "vdCA /AT:C /CFile:D:\AutoCheckIn.ini /Password:changeit /Account:Versiondog"
    check_in = subprocess.check_output(cmdlet_check_in, shell=True).decode("utf-8")
    if len(check_in) == 0:
        # ctypes.windll.user32.MessageBoxW(0, "Check in function proceed successfully", "Succes", 0)
        return "VDogAutoCheckIn.exe proceed successfully"
    else:
        if "Maintenance" in check_in:
            # ctypes.windll.user32.MessageBoxW(0, "The server is in maintainance, please try again when it's done", "Succes", 0)
            return "VersionDog server is in maintainance, can proceed this process"
        else:
            # ctypes.windll.user32.MessageBoxW(0, check_in,"Error", 0)
            return "VDogAutoCheckIn.exe proceed fail"

def send_mail():
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
    
def create_json_report():
    status_check_in = check_in_fucntion()
    status_check_out = check_out_function()
    report_json = {
            "data":
                {
                    "function": "[Automation] Routine Check In/Check Out",
                    "time": str(datetime.date.today()),
                    "exist": True,
                    "status":
                        {
                            "status_check_in": status_check_in,
                            "status_check_out": status_check_out
                        }
                }
        }    
    with open("D:/vdSA/report_routine.json", 'w') as f:
        f.write(json.dumps(report_json,indent=4))   
create_json_report()
# send_mail()


