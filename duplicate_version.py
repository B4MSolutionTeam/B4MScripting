import os
import datetime
from dateutil.relativedelta import relativedelta
from sympy import re
import re
backup_path = "./Bu/"
old_version_file = []
# for i in os.scandir(backup_path):
#     date_backup_file = datetime.date.fromtimestamp(os.path.getctime(i))
#     print((datetime.date.today() - date_backup_file).days)
#     if (datetime.date.today() - date_backup_file).days > 43:
#         old_version_file.append(i)


def check_sub_folder(list_subfolder, temp_path):
    path_subfolder = ""
    list_path_subfolder = []
    for i in list_subfolder:
        path_subfolder = temp_path + "/" + i
        list_path_subfolder.append(path_subfolder)
    return list_path_subfolder
backup_file_attribute = []   
def path_finder(path):
    check_exist = True
    while check_exist is True:
        for i in os.walk(path):
            if len(i[1]) == 0:
                continue
            elif len(i[1]) > 0:
                for path_subfolder in i[1]:
                    x = re.search(r"^\d\d\d\d\d\d\d\d\.\d\d\d$",str(path_subfolder))
                    if x:
                        for scan_dir in os.scandir(path):
                            date_packup_file = datetime.date.fromtimestamp(os.path.getctime(scan_dir))
                            backup_file_attribute.append(date_packup_file)
                list_check_subfolder = check_sub_folder(i[1], path)
                for path_sub_folder in list_check_subfolder:
                    path_finder(path_sub_folder)
                    
                    
        
for i in os.walk(backup_path):
    if i[0].endswith("ARCHIVE") is True:
        path_update = i[0].replace("\\","/") #replace special character 
        if len(i[1]) > 0: #check if sub folder of ARCHIVE are exist
            temp_path = path_update
            path_finder(temp_path)
# for i in os.walk(backup_path):
#     print(i)