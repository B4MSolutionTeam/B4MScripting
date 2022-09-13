import subprocess
from asyncio.windows_events import NULL
from base64 import decode, encode
import csv
from re import L
from tabnanny import check
from time import sleep
import os
import datetime

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

xml_file = []
for xml in os.listdir("C:/vdSA/New folder/"):
    xml_file.append(xml[:-4])
    
header = []
with open("C:/vdSA/data2.csv",'r') as f:
    csvreader = csv.reader(f)
    csvreader = list(csvreader)
    for i in csvreader[0]:
        header.append(i)
        
list_final = []
with open("C:/vdSA/data3.csv",'r') as f:
    csvreader = csv.reader(f)
    csvreader = list(csvreader)
    
    for i in csvreader[1:]:
        check_final = True
        if i[4] in xml_file:
            file_xml = open("C:/vdSA/New folder/{}.xml".format(i[4]),'r',encoding="UTF-8")
            content = file_xml.read()
            item = BeautifulSoup(content,'xml')
            for elem in item.find_all("item"):
                if elem['display'] == 'Pfad':
                    replace_pfad = (elem.get_text()).replace("\\","/")
                    check = True
                    for tuple_pfad in os.walk(replace_pfad):
                        
                        if len(tuple_pfad[2]) > 0:
                            a = (tuple_pfad[2][len(tuple_pfad[2])-1]).split(".")
                            if "sna" in a or "SNA" in a:
                                date_time_final = datetime.date.fromtimestamp(os.path.getmtime(replace_pfad + "/{}".format(tuple_pfad[2][len(tuple_pfad[2])-1])))
                                date_time_first = datetime.date.fromtimestamp(os.path.getmtime(replace_pfad + "/{}".format(tuple_pfad[2][0])))
                                if date_time_final < datetime.date(2022,7,19) and date_time_final > datetime.date(2022,6,1):
                                    check = False 
                                    check_final = False
                        break
                    if check == False:
                        for elem1 in item.find_all("item"): 
                            if elem1['display'] == "Optionen" or elem1['display'] == "Options":
                                if elem1.get_text() is None:
                                    i.append("")
                                else:
                                    i.append("{}".format(elem1.get_text()))
                            else:
                                i.append("{}".format(elem1.get_text()))
        if check_final == False:
            list_final.append(i)
        
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
                
            
file_header = open("C:/vdSA/New folder/006C7EAD043243E59B4085B2C2C85D2F.xml",'r',encoding="utf-8")   
item_header = file_header.read()
item = BeautifulSoup(item_header,'xml')
for elem_header in item.find_all("item"):
    a = elem_header['display'] 
    header.append(a)

# with open("C:/vdSA/NewJobList_Complete.csv",'w', newline='', encoding='utf-8') as data3:   
#     writer = csv.writer(data3)
#     writer.writerow(header)
#     writer.writerows(list_final)
    

from xlwt import Workbook

wb = Workbook()
length_of_header = len(header)
sheet1 = wb.add_sheet("Sheet 1")
for i in range(0,len(header)):
    sheet1.write(0,i,header[i])

for i in range(1, len(list_final)):
    c = 0
    for ele in list_final[i]:
        if c < length_of_header:
            sheet1.write(i, c, ele)
            c=c+1
            
wb.save("test.xls")

# # for i in os.walk("//10.16.193.18/cos/CRI_Montage/EMI_S06_002A610_BA1005358_W1886"):
# #     print(i)