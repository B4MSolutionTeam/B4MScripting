import csv
import os
import datetime
import re
import subprocess

backup_path = "C:/vdServerAchieve"
factory_name = {"Ba":"Factory Bamberg", "Bu": "Factory Bursa"}

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
                    
                    factory = factory_name[(path_check_version.split("/"))[2]]
                    HDEV6 = (path_check_version.split("/"))[3]
                    stage = (path_check_version.split("/"))[4]
                    production_line = (path_check_version.split("/"))[5]
                    number = (path_check_version.split("/"))[6]
                    component = (path_check_version.split("/"))[8]
                    version_folder = (path_check_version.split("/"))[-1]
                    x = re.search(r"^\d\d\d\d\d\d\d\d\.\d\d\d$", version_folder)
                    if x:
                        date_packup_file = datetime.date.fromtimestamp(os.path.getctime(path_check_version))
                        if float((datetime.date.today() - date_packup_file).days)* 0.002738 > 0.005476:
                            backup_file_attribute_time.update({path_check_version:[factory, HDEV6, stage, production_line,number, component ,path_check_version, date_packup_file]})
        path = list_path_subfolder_achieve
    
def create_report():
    with open("C:/vdServerAchieve/report.csv", 'w', encoding="UTF8") as f:
        header = ["Factory", "HDEV6","Stage", "Product Line","Number", "Component", "Path", "Create Date"]
        writer = csv.writer(f)
        writer.writerow(header)
        print(type(backup_file_attribute_time.values()))
        writer.writerows(backup_file_attribute_time.values())
        
def send_mail():
    p = subprocess.check_output("powershell -file C:/vdServerAchieve/sendmail.ps1", shell = True)
    print(p)   
    
backup_file_attribute_time = {}  
        
for i in os.walk(backup_path):
    if i[0].endswith("ARCHIVE") is True:
        path_update = i[0].replace("\\","/") #replace special character 
        if len(i[1]) > 0: #check if sub folder of ARCHIVE are exist
            temp_path = [path_update]
            count_path = 0
            general_check_sub_folder(temp_path)
create_report()
send_mail()

