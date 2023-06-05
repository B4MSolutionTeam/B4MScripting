
import subprocess
import smtplib
import datetime
from email.mime.text import MIMEText
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
import json 

def decrypt_password():
    output = subprocess.run(["powershell","-Command", "\\\\hc10fs02.apac.bosch.com\\TAD6HC$\\pki_data\\AES_Decrypt.ps1"],capture_output=True)
    decode_output = str(output.stdout.decode("UTF-8"))

    decrypt_string = decode_output.split("\n")
    list_decrypt_string = []
    for i in decrypt_string:
        list_decrypt_string.append(i.replace("\r",""))

    return list_decrypt_string[0]

def encrypt_password():
    output = subprocess.run(["powershell","-Command","\\\\hc10fs02.apac.bosch.com\\TAD6HC$\\pki_data\\AES_Encrypt.ps1"],capture_output=True)
    decode_output = str(output.stdout.decode("UTF-8"))
    print(decode_output)
    key_plaintext= decode_output.split("\n")
    list_key_plaintex = []

    for i in key_plaintext:
        i.replace("\\r","")
        list_key_plaintex.append(i[:-1])

    f = open("//hc10fs02.apac.bosch.com/TAD6HC$/pki_data/password.txt", 'w')
    f.write("{} {}".format(list_key_plaintex[0],list_key_plaintex[1]))
    
def check_out_function(password):
    # 060 D:\vdClient\VDogAutoCheckOut.exe /rd:D:\vdogData /AT:C /DirR:Training\test_duy\ASCII /CID:891F9A068AFD464ABD8AB29D5A8BD8FF /Password:Haha050399@@ /Account:tad6hc /Domain:apac
    # 153 D:\vdClient\VDogAutoCheckOut.exe /rd:D:\vdCA /AT:C /DirR:\Ba\test\Json3 /CID:CDFCBC9C02CB4E238B91125CD1E38AF6 /Account:Versiondog /Password:changeit
    # 061 C:\Users\TAD6HC\Desktop\vdogClient\VDogAutoCheckOut.exe /rd:D:\vdCA /AT:C /DirR:\Duy_Test\Ascii /CID:6414A0762A6847D4984354040774DDD9 /Password:Haha050399@@ /Account:tad6hc /Domain:apac
    #cmdlet_check_out = "D:" + '\\'+"vdClient\VDogAutoCheckOut.exe" + ' /' +"rd:d:"+ '\\' + "vdCA /at:c /dirR:\Ba\HDEV6" + '\\' + "test\Json3 /CID:CDFCBC9C02CB4E238B91125CD1E38AF6 /Account:Versiondog /Password:changeit"
    
    # cmdlet_check_out = "D:" + '\\'+"vdClient\VDogAutoCheckOut.exe" + ' /' +"rd:d:"+ '\\' + "vdCA /at:c /dirR:\Ba"+ '\\' +"test\Json3 /CID:CDFCBC9C02CB4E238B91125CD1E38AF6 /Account:Versiondog /Password:change_it"
    cmdlet_check_out = r"C:\Users\TAD6HC\Desktop\vdogClient\VDogAutoCheckOut.exe /rd:D:\vdCA /AT:C /DirR:\Duy_Test\Ascii /CID:6414A0762A6847D4984354040774DDD9 /Password:{} /Account:tad6hc /Domain:apac".format(password)
    try:
        check_out = (subprocess.check_output(cmdlet_check_out, shell=True)).decode("utf-8")
        if "INF" in check_out.split(" ")[0]:
            return "Check Out successfully"
        else:
            return "Check Out fail."
    except Exception as e:
        if "non-zero exit status 1" in str(e):
            return "vDog server is in maintainance, can't proceed this process"
    
        
def check_in_fucntion(password):
    # 060 D:\vdClient\VDogAutoCheckIn.exe /RD:d:\vdogData /AT:C /CFile:D:\AutoCheckIn.ini /Password:Haha050399@@ /Account:tad6hc /Domain:apac
    # 153 D:\vdClient\VDogAutoCheckIn.exe /RD:D:\vdCA /AT:C /CFile:D:\AutoCheckIn.ini /Password:changeit /Account:Versiondog"
    # 061 C:\Users\TAD6HC\Desktop\vdogClient\VDogAutoCheckIn.exe /RD:D:\vdCA /AT:C /CFile:D:\AutoCheckIn.ini /Password:Haha050399@@ /Account:tad6hc /Domain:apac
    try:
        # cmdlet_check_in = "D:" + '\\'+"vdClient\VDogAutoCheckIn.exe" + " /RD:D:" + '\\' "vdCA /AT:C /CFile:D:\AutoCheckIn.ini /Password:change_it /Account:Versiondog"
        cmdlet_check_in = r"C:\Users\TAD6HC\Desktop\vdogClient\VDogAutoCheckIn.exe /RD:D:\vdCA /AT:C /CFile:D:\AutoCheckIn.ini /Password:{} /Account:tad6hc /Domain:apac".format(password)
        check_in = (subprocess.check_output(cmdlet_check_in, shell=True)).decode("utf-8")
        # ctypes.windll.user32.MessageBoxW(0, check_in, u"Error", 0)
        if len(check_in) == 0:
            # ctypes.windll.user32.MessageBoxW(0, "Check in function proceed successfully", "Succes", 0)
            return "Check In successfully"
        elif len(check_in) != 0:
            
            if "ERR SQLException" in check_in:
                return "Database is probaly already opened by another engine in another Window session, can't proceed this process"
        
            elif "[22313]" in check_in:
                return "There is no backup version created"
            else:
                return "Check In proceed fail"
    except Exception as e:
        if "non-zero exit status 1" in str(e):
            return "vDog server is in maintainance, can't proceed this process"
        
    
def send_mail():
    SUBJECT = "[Automation] Check In, Check Out Testing"
    recipent = ["an.phamnhat@vn.bosch.com", "vu.nguyenhoanganh@vn.bosch.com"]
    msg = MIMEMultipart()
    msg['Subject'] = SUBJECT 
    msg['From'] = "Duy.TaThai@vn.bosch.com"
    msg['To'] = ", ".join(recipent)

    part = MIMEBase('application', "octet-stream")
    part.set_payload(open("D:/vdServerArchive/report.csv", "rb").read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename="report.csv"')

    msg.attach(MIMEText("Dear all,\n We would like to report the status of status of Check In/Check Out Function:\n+ \tCheck Out status:","plain"))
    msg.attach(part)

    server = smtplib.SMTP("rb-smtp-int.bosch.com")
    server.sendmail("Duy.TaThai@vn.bosch.com",recipent, msg.as_string())
    
def create_json_report():
    password = decrypt_password()
    status_check_in = ""
    status_check_in = check_in_fucntion(password)
    status_check_out = check_out_function(password)
    report_json = {
            "data":
                {
                    "function": "[Automation] Routine Check In/Check Out",
                    "time": str(datetime.date.today()),
                    "exist": True,
                    "server": "BA0VM061",
                    "status":
                        {
                            "status_check_in": status_check_in,
                            "status_check_out": status_check_out
                        }
                }
        }    
    with open("D:/Report_Daily/report_1_061.json", 'w') as f:
        f.write(json.dumps(report_json,indent=4))   
create_json_report()
encrypt_password()
# send_mail()

