import hashlib
import os
from time import sleep
from zipfile import ZipFile
from deepdiff import DeepDiff
import json
count = 0
dict_total = {}

json_duplicate = {
        "list_duplicate":[]
    }


def check_duplicate(json_string):          
    count_list_1 = 0
    length_version = len(json_string["file_contain"])
    
    if len(json_string["file_contain"]) > 2:
        list_duplicate_path_with_list_1 = []
        while count_list_1 != length_version:
            path1 = ""
            count_list_2 = count_list_1 + 1
            list_duplicate_path_with_list_1 = []
            while count_list_2 != (length_version):
                if len((json_string["file_contain"])[count_list_1]) == len((json_string["file_contain"])[count_list_2]):
                    ddiff = DeepDiff(((json_string["file_contain"])[count_list_1])["element"], ((json_string["file_contain"])[count_list_2])["element"])
                    dict_ddiff = ddiff.to_dict()
                    if len(dict_ddiff.keys()) == 0:
                        path1 = (((json_string["file_contain"])[count_list_1])["path_zip"])
                        print("{} and {} is the same".format((((json_string["file_contain"])[count_list_1])["path_zip"]), (((json_string["file_contain"])[count_list_2])["path_zip"])))
                        list_duplicate_path_with_list_1.append((((json_string["file_contain"])[count_list_2])["path_zip"]))
                count_list_2 = count_list_2 + 1
            count_list_1 = count_list_1 + 1
            if count_list_1 == length_version:
                break
            if len(list_duplicate_path_with_list_1) > 0:
                json_duplicate["list_duplicate"].append({"path":path1,"dup_path":list_duplicate_path_with_list_1})
    
    
    
def get_md5Hash(path, number_version): 
    print(path)
    list_total = []
    archive_zip_path = ""
    count = 0
    list_archive_zip_path = []
    for i in os.walk(path):
        list_small = []
        if len(i[1]) == 0 and "Archive.zip" in i[2]:
            archive_zip_path = str(i[0].replace("\\","/"))
            archive_zip_path = archive_zip_path + "/Archive.zip"
            list_archive_zip_path.append(archive_zip_path)
            with ZipFile(archive_zip_path, 'r' ) as zip:
                for filename in zip.namelist():
                    if filename.endswith("/") == False:
                        content_file = zip.open(filename).read()
                        md5_hash = hashlib.md5(content_file).hexdigest()
                        list_small.append({"file_in_zip":filename,"file_md5":md5_hash})
            count = count + 1 
            list_total.append({"path_zip": archive_zip_path, "element":list_small})
        if count == number_version:
            break
    json_string = {
        "path_contain": path,
        "file_contain": list_total
    }
    if len(json_string["file_contain"]) > 1:
        check_duplicate(json_string)

#\\ba0vm061.de.bosch.com\duy\10_Load
for i in os.walk("//ba0vm060.de.bosch.com/vdServerArchive/Ba"):
    if(len(i[0].split("\\")) > 1):
        if "ARCHIVE" in (i[0].split("\\"))[-2]:
            get_md5Hash(i[0].replace("\\","/"), len(i[1]))
            
print(json.dumps(json_duplicate, indent= 4))

list_to_remove = []
json_duplicate_2 = json_duplicate
for duplicate_2 in json_duplicate_2["list_duplicate"]:
    for duplicate_path_2 in duplicate_2["dup_path"]:
        for duplicate_1 in json_duplicate["list_duplicate"]:
            if duplicate_path_2 == duplicate_1["path"]:
                if duplicate_1 not in list_to_remove:
                    list_to_remove.append(duplicate_1)
                
print(list_to_remove)
for i in list_to_remove:
    json_duplicate["list_duplicate"].remove(i)
    
json_object = json.dumps(json_duplicate, indent= 4)
with open("D:/vdSA/Report_Daily/Duplicate_Report.json", 'w') as f:
    f.write(json_object)

