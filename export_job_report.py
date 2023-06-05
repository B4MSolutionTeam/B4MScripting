

import subprocess
import csv
from re import L
import os
import datetime
import sys
from time import sleep
import pandas as pd
import json

# with open("C:/vdSA/NewJobList.csv",'r') as f:
#     csvreader = csv.reader(f)
#     csvreader = list(csvreader)
#     data_header = ((csvreader[0])[0]).split(";")
#     data_body = csvreader[1:]
#     header = []
#     data = []
#     for i in data_header:
#         header.append(i.replace('"',''))
#     for body in data_body:
#         data2 =[]
#         for i in body[0].split(";"):
#             data2.append(i.replace('"',""))
#         data.append(data2)
#     f.close()
# with open("C:/vdSA/NewJobList_data2.csv",'w', newline='',encoding="UTF-8") as f:
#     writer = csv.writer(f)
#     writer.writerow(header)
#     writer.writerows(data)
#     f.close()
    

    
# with open("C:/vdSA/NewJobList_data2.csv",'r') as f:
#     csvreader = csv.reader(f)
#     csvreader = list(csvreader)
    
#     final_data = [[]]
    
#     for i in csvreader[1:]:
#         check = False
#         for data in final_data:
#             try:
#                 if i[6] == "DiskImage":
#                     check = True
#                 else:
#                     check = False  
#             except Exception as e:
#                 continue  
#         if check == True:    
#             final_data.append(i)
#     f.close()

# with open("C:/vdSA/NewJobList_data3.csv",'w', newline='',encoding="UTF-8") as data3:   
#     writer = csv.writer(data3)
#     # writer.writerow(header)
#     writer.writerows(final_data)
#     data3.close()

from bs4 import BeautifulSoup


# for i in soup.find_all("item"):
#     print(i.get_text())

# xml_file = []
# for xml in os.listdir("C:/vdSA/New folder/"):
#     xml_file.append(xml[:-4])
    
# header = []
# with open("C:/vdSA/data2.csv",'r') as f:
#     csvreader = csv.reader(f)
#     csvreader = list(csvreader)
#     for i in csvreader[0]:
#         header.append(i)
        
# list_final = []
# with open("C:/vdSA/data3.csv",'r') as f:
#     csvreader = csv.reader(f)
#     csvreader = list(csvreader)
    
#     for i in csvreader[1:]:
#         check_final = True
#         if i[4] in xml_file:
#             file_xml = open("C:/vdSA/New folder/{}.xml".format(i[4]),'r',encoding="UTF-8")
#             content = file_xml.read()
#             item = BeautifulSoup(content,'xml')
#             for elem in item.find_all("item"):
#                 if elem['display'] == 'Pfad':
#                     replace_pfad = (elem.get_text()).replace("\\","/")
#                     check = True
#                     for tuple_pfad in os.walk(replace_pfad):
                        
#                         if len(tuple_pfad[2]) > 0:
#                             a = (tuple_pfad[2][len(tuple_pfad[2])-1]).split(".")
#                             if "sna" in a or "SNA" in a:
#                                 date_time_final = datetime.date.fromtimestamp(os.path.getmtime(replace_pfad + "/{}".format(tuple_pfad[2][len(tuple_pfad[2])-1])))
#                                 date_time_first = datetime.date.fromtimestamp(os.path.getmtime(replace_pfad + "/{}".format(tuple_pfad[2][0])))
#                                 if date_time_final < datetime.date(2022,7,19) and date_time_final > datetime.date(2022,6,1):
#                                     check = False 
#                                     check_final = False
#                         break
#                     if check == False:
#                         for elem1 in item.find_all("item"): 
#                             if elem1['display'] == "Optionen" or elem1['display'] == "Options":
#                                 if elem1.get_text() is None:
#                                     i.append("")
#                                 else:
#                                     i.append("{}".format(elem1.get_text()))
#                             else:
#                                 i.append("{}".format(elem1.get_text()))
#         if check_final == False:
#             list_final.append(i)
        
                #     else:
                #         if elem['display'] == "Pfad":
                #             replace_pfad = (elem.get_text()).replace("\\","/")
                #             check = True
                #             for tuple_pfad in os.walk(replace_pfad):
                #                 if len(tuple_pfad[2]) > 0:
                #                     a = (tuple_pfad[2][len(tuple_pfad[2])-1]).split(".")
                #                     if "sna" in a or "SNA" in a:
                #                         date_time_final = datetime.date.fromtimestamp(os.path.getmtime(replace_pfad + "/{}".format(tuple_pfad[2][len(tuple_pfad[2])-1])))
                #                         if date_time_final < datetime.date(2022,7,19) and date_time_final > datetime.date(2022,6,1):
                #                             check = False
                #                 break
                #             if check == False:
                                
                #                 i.append("{}".format(elem.get_text()))
                            
                                
                                
                #         else:
                #             i.append("'{}'".format(elem.get_text()))               
                # else:
                #     if elem.get_text() is None:
                #         i.append("")
                #     else:
                #         if elem['display'] == "Pfad":
                #             replace_pfad = (elem.get_text()).replace("\\","/")
                #             check = True
                #             for tuple_pfad in os.walk(replace_pfad):
                #                 if len(tuple_pfad[2]) > 0:
                #                     a = (tuple_pfad[2][len(tuple_pfad[2])-1]).split(".")
                #                     if "sna" in a or "SNA" in a:
                #                         date_time_final = datetime.date.fromtimestamp(os.path.getmtime(replace_pfad + "/{}".format(tuple_pfad[2][len(tuple_pfad[2])-1])))
                #                         if date_time_final < datetime.date(2022,7,19) and date_time_final > datetime.date(2022,6,1):
                #                             check = False
                #                 break
                #             if check == False:
                #                 i.append("{}".format(elem.get_text()))
                #         else:
                #             i.append("'{}'".format(elem.get_text()))
                
            
# file_header = open("C:/vdSA/New folder/006C7EAD043243E59B4085B2C2C85D2F.xml",'r',encoding="utf-8")   
# item_header = file_header.read()
# item = BeautifulSoup(item_header,'xml')
# for elem_header in item.find_all("item"):
#     a = elem_header['display'] 
#     header.append(a)

# with open("C:/vdSA/NewJobList_Complete.csv",'w', newline='', encoding='utf-8') as data3:   
#     writer = csv.writer(data3)
#     writer.writerow(header)
#     writer.writerows(list_final)
    

# from xlwt import Workbook

# wb = Workbook()
# length_of_header = len(header)
# sheet1 = wb.add_sheet("Sheet 1")
# for i in range(0,len(header)):
#     sheet1.write(0,i,header[i])

# for i in range(1, len(list_final)):
#     c = 0
#     for ele in list_final[i]:
#         if c < length_of_header:
#             sheet1.write(i, c, ele)
#             c=c+1
            
# wb.save("test.xls")

# # for i in os.walk("//10.16.193.18/cos/CRI_Montage/EMI_S06_002A610_BA1005358_W1886"):
# #     print(i)

#########################################################################################

df = pd.read_excel("C:/Users/TAD6HC/Downloads/JobList_Complete.xls")

######################################
def return_last_file(file_pfad, pfad_path):
    list_return = []
    
    for file in file_pfad[2]:
        if ".sna" in file or ".SNA" in file:
            list_return.append(datetime.date.fromtimestamp(os.path.getmtime(pfad_path + "/" + file)))
    if len(list_return) > 0: 
        print(list_return[-1])
        if list_return[-1] > datetime.date(2022,9,15):
            return (pfad_path, "Success")
        else:
            return (pfad_path, "Fail")
    elif len(list_return) == 0:
        return (pfad_path, "Fail")
list_total = []
for pfad_path in df["Pfad"]:
    sub_folder = ""
    for file_pfad in os.walk(pfad_path):
        print(file_pfad[0])
        if len(sub_folder) > 0:
            list_pfad_path = (file_pfad[0]).split("\\")
            print(list_pfad_path)
            if list_pfad_path[-1] in sub_folder:
                continue
            
        if len(file_pfad[1]) > 0:
            sub_folder = file_pfad[1]
            list_total.append(return_last_file(file_pfad,pfad_path))
            
        else:
            list_total.append(return_last_file(file_pfad,pfad_path))
print(len(list_total))

count = 0 
import xlwt
import xlrd
from xlutils.copy import copy
workbook = xlrd.open_workbook("C:/Users/TAD6HC/Downloads/JobList_Complete.xls") 
wb = copy(workbook)
w_sheet = wb.get_sheet(0)
w_sheet.write(0,79,'Status')
w_sheet.write(0,80,"Status Configure")
count = 1

for i in list_total:
    print(i)

    w_sheet.write(count,79,i[1])
    count = count + 1
wb.save("C:/Users/TAD6HC/Downloads/JobList_Complete_New_{}.xls".format((datetime.date.today()).strftime("%d-%m-%Y")))
#####################################################    #

df1 = pd.read_excel("C:/Users/TAD6HC/Downloads/JobList_Complete_New_{}.xls".format((datetime.date.today()).strftime("%d-%m-%Y")))
csv_string = df1.to_csv()
f = open("test.txt",'w',newline='')
f.write(csv_string)
csv_reader = ""
with open("test.txt") as csv_file:
    csv_reader = csv.reader(csv_file, delimiter=',')
    csv_reader = list(csv_reader)
list_change = {"change": []}
row = 1
for csv_record in csv_reader[1:]:
    # print(csv_record)
    job_id = csv_record[6]
    with open("C:/XMLFile/{}.xml".format(job_id)) as xml_file:
        data_xml = xml_file.read()
        tag_items = BeautifulSoup(data_xml, features= "xml")
        list_value_tag = []
        for each_item in tag_items.find_all("item"):
            value_of_item = each_item.get_text()
            list_value_tag.append(value_of_item)
        
    # print(list_value_tag)
    count = 0
    list_a = csv_record[40:-2]
    list_b = list_value_tag
    column = 39
    if len(list_a) == len(list_b):
        while count < len(list_b):
            if list_a[count] == list_b[count]:
                # print("{} is the same with {}".format(list_a[count], list_b[count]))
                print("")
            else:
                # print("{} is not the same with {}".format(list_a[count], list_b[count]))
                list_change["change"].append({"old_value": list_a[count], 
                                              "new_value": list_b[count],
                                              "column": column,
                                              "row": row})
            # sleep(1)
            count = count + 1
            column = column + 1
    row = row + 1
    # print(list_change)
    # break
count = 0 
import xlwt
import xlrd
from xlutils.copy import copy

book = xlwt.Workbook()
xlwt.add_palette_colour("custom_colour", 0x21)
book.set_colour_RGB(0x21, 251, 228, 228)
sheet1 = book.add_sheet('{}'.format((datetime.date.today()).strftime("%d-%m-%Y")))
style = xlwt.easyxf('pattern: pattern solid, fore_colour custom_colour')
for i in list_change["change"]:
    # print(i)
    sheet1.write(i["row"], i["column"], 'Some text', style)
book.save("C:/Users/TAD6HC/Downloads/JobList_Complete_New_{}_1.xls".format((datetime.date.today()).strftime("%d-%m-%Y")))

workbook = xlrd.open_workbook("C:/Users/TAD6HC/Downloads/JobList_Complete_New_{}.xls".format((datetime.date.today()).strftime("%d-%m-%Y"))) 
wb = copy(workbook)
w_sheet = wb.get_sheet(0)
for i in list_change["change"]:
    w_sheet.write(i["row"], i["column"], i["new_value"],style)

wb.save("C:/Users/TAD6HC/Downloads/JobList_Complete_New_{}_1.xls".format((datetime.date.today()).strftime("%d-%m-%Y")))
    
        