

import os
from time import sleep
from html2image import Html2Image


path = "C:/test/"

hti = Html2Image(browser_executable='C:/test/Application/chrome.exe', output_path='C:/hello/')
# sleep(10)
list_file = os.listdir(path)
path_result = hti.screenshot(html_file='C:/test/CPU_Ba0VM00298.html', size=(1053,332),save_as="report_5.png")
# for file in list_file:
#     if ".html" in file:
#         # hti.output_path=path
#         #1053,332
#         path_result = hti.screenshot(html_file='C:/test/CPU_Ba0VM00298.html', size=(1053,332),save_as="report_5_{}.png".format(file[0:-5]))
#         sleep(1)
        
#         # os.remove(path+"{}".format(file))   
#         print(path_result)
#         print(os.listdir(path))
# sleep(5)

# for file in list_file:
#     if ".html" in file:
#         os.remove(path+file)

# print("Execute")
# for i in os.listdir(path):
#     if "Disk_Utilization" in i and ".json" in i:
#         data_dump = subprocess.run(["powershell","-Command","ConvertTo-Json -InputObject (Get-Content '{}{}' | ConvertFrom-Json) -Depth 5".format(path.replace("/","\\"),i)],capture_output=True)
#         data_dump = (data_dump.stdout).decode('utf-8')
#         data_dump = json.loads(data_dump)
#         data = data_dump["data"]
#         list_x = []
#         list_y = []
#         for data_drive in data:
#             print(data_drive['drive'] + " " + data_dump["server_name"])
#             for data_drive_element in data_drive["data_drive"]:
                
#                 list_y.append(data_drive_element['time'])
#                 list_x.append(round((float(data_drive_element['free'])/float(data_drive['size']))*100, 1))
                
#             print(list_x)
#             print(list_y)
#             plt.plot(list_y, list_x, label = "{}//{}".format(data_dump["server_name"],data_drive["drive"]))        
#             list_y.clear()
#             list_x.clear()
            
# plt.ylim(0,100)

# plt.xlabel("Time Line ({})".format((datetime.date.today()).strftime("%d/%m/%Y")))
# plt.ylabel("% Free Space")
# plt.title("Disk Utilization {}".format((datetime.date.today()).strftime("%d/%m/%Y")))
# plt.legend(loc="best", ncol=2)
# fig = plt.gcf()
# fig.set_size_inches(15.625, 4.1666666667)
# plt.savefig("{}Disk_Utilization.png".format(path))

