import csv
import json
import os
import datetime
import re
import ctypes
from email.mime.text import MIMEText
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

backup_path = "D:/vdServerArchive/Ba/HDEV6/"
factory_name = {"Ba":"BaP", "Bu": "BuP"}

def check_sub_folder(list_subfolder, temp_path):
    path_subfolder = ""
    list_path_subfolder = []
    for i in list_subfolder:
        path_subfolder = temp_path + "/" + i
        list_path_subfolder.append(path_subfolder)
    return list_path_subfolder

def connect_path(list_of_subfolder_archieve, path):
    list_path_subfolder_achieve = []
    for subfolder_achieve in list_of_subfolder_archieve:
        path_subfolder_achieve = path + "/" + str(subfolder_achieve)
        list_path_subfolder_achieve.append(path_subfolder_achieve)
        
    for path_subfolder_achieve in list_path_subfolder_achieve:
        for sub in list(os.walk(path_subfolder_achieve)):
            if len(sub[1]) > 0:
                return list_path_subfolder_achieve, True
            else:
                return list_path_subfolder_achieve, False
    
def status_check(path):
    for path_of_achieve in os.walk(path):
            if len(path_of_achieve[1]) > 0:
                list_path_subfolder_achieve, check = connect_path(path_of_achieve[1], path)
                return list_path_subfolder_achieve, check
            
def general_check_sub_folder(path):
    check = True
    list_path_subfolder_achieve = []
    while check is True:
        
        for p in path:
            list_path_subfolder_achieve, check = status_check(p)
            if check is False:
                for path_check_version in list_path_subfolder_achieve:
                    print(path_check_version.split("/"))
                    
                    factory = factory_name[(path_check_version.split("/"))[2]]
                    HDEV6 = (path_check_version.split("/"))[3]
                    index_of_HDEV6 = (path_check_version.split("/")).index("HDEV6")
                    index_of_ARCHIVE = (path_check_version.split("/")).index("ARCHIVE")
                    stage_production_SL = "/"
                    if index_of_ARCHIVE - index_of_HDEV6 > 1:
                        for st_pr_sl in (path_check_version.split("/"))[index_of_HDEV6+1:index_of_ARCHIVE]:
                            stage_production_SL = stage_production_SL + st_pr_sl + "/"
                    print(stage_production_SL)
                    component = path_check_version.split("/")[index_of_ARCHIVE+1]
                    version_folder = (path_check_version.split("/"))[-1]
                    x = re.search(r"^\d\d\d\d\d\d\d\d\.\d\d\d$", version_folder)
                    if x:
                        date_packup_file = (datetime.date.fromtimestamp(os.path.getmtime(path_check_version)))
                        #ctypes.windll.user32.MessageBoxW(0, str(float((datetime.date.today() - date_packup_file).days)* 0.002738), u"Error", 0)
                        if float((datetime.date.today() - date_packup_file).days)* 0.002738 > float(1):
                            backup_file_attribute_time.update({path_check_version:[factory, HDEV6, stage_production_SL, component ,path_check_version, date_packup_file, float((datetime.date.today() - date_packup_file).days)* 0.002738]})
        path = list_path_subfolder_achieve
            
    
def create_report():
    with open("D:/vdServerArchive/report_060.csv",'w', newline='', encoding="UTF-8") as f:
        header = ["Factory", "Value Stream","Stage/Product Line/SL", "Component", "Path", "Create Date"]
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(backup_file_attribute_time.values())
        
def create_json_report():
    if len(backup_file_attribute_time.values()) > 0:
        report_json = {
            "data":
                {
                    "function": "[Automation] Duplicate Version Tool",
                    "time": str(datetime.date.today()),
                    "exist": True, 
                    "num": str(len(backup_file_attribute_time.values())),
                    "overdate_version":
                        [
                            
                        ]
                }
        }
    for attribute_list in backup_file_attribute_time.values():
        attribute_dict = {
            "factory_name": attribute_list[0],
            "path": attribute_list[4],
            "create_date": attribute_list[5].strftime("%d/%m/%Y"),
            "date_year": attribute_list[6]
        }
        report_json["data"]["overdate_version"].append(attribute_dict)
    with open("D:/vdServerArchive/report_3_060.json", 'w') as f:
        f.write(json.dumps(report_json,indent=4))
        
def send_mail():
    # p = subprocess.check_output("powershell -file D:/vdServerArchive/sendmail.ps1", shell = True)
    # print(p)   
    SUBJECT = "Backup Version Overdate 10 year"
    recipent = ["an.phamnhat@vn.bosch.com"]
    msg = MIMEMultipart()
    msg['Subject'] = SUBJECT 
    msg['From'] = "Duy.TaThai@vn.bosch.com"
    msg['To'] = ", ".join(recipent)

    part = MIMEBase('application', "octet-stream")
    part.set_payload(open("D:/vdServerArchive/report.csv", "rb").read())
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename="report.csv"')

    msg.attach(MIMEText("Hello, after examine all file backup version, we have discovered these files are overdate. Please kindly review and delete these files. Thank you", 'plain'))
    msg.attach(part)

    server = smtplib.SMTP("rb-smtp-int.bosch.com")
    server.sendmail("Duy.TaThai@vn.bosch.com","an.phamnhat@vn.bosch.com", msg.as_string())
    
backup_file_attribute_time = {}  
        
for i in os.walk(backup_path):
    if i[0].endswith("ARCHIVE") is True:
        path_update = i[0].replace("\\","/") #replace special character 
        if len(i[1]) > 0: #check if sub folder of ARCHIVE are exist
            temp_path = [path_update]
            count_path = 0
            general_check_sub_folder(temp_path)
if len(backup_file_attribute_time.values()) > 0:
    create_report()
    create_json_report()
    # send_mail()
