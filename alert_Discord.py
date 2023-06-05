import discord 
import aiohttp
import time
import subprocess
import os
import json
from tabulate import tabulate
import re
TOKEN = 'MTA1NTA4MTg4NjUwMzk0NDIwMw.GnyNkL.puT73QllE3gAzbJ1OnnmCom_G7sUUoLQLo26G4' 
intents = discord.Intents().all() 
client = discord.Client(intents=intents, proxy="http://rb-proxy-apac.bosch.com:8080", proxy_auth=aiohttp.BasicAuth("APAC\BMT8HC","B4m013209112022@")) 
# client = discord.Client(intents=intents)
flag_count =[  
                {"BA0VM153":
                    {"e01":[
                        {"Confirm":["Bi#6885"]},
                        {"Denied":["Bi#6885"]}
                            ],
                        "error_message":'[BA0VM153]-[e01]-Server BA0VM153.de.bosch.com is down and need to be restart. Please type "/e01-Confirm-BA0VM153" or "/e01-Denied-BA0VM153"'
                    }
                },
                {"BA0VM060":
                    {"e01":[
                        {"Confirm":["Bi#6885"]},
                        {"Denied":["Bi#6885"]}
                            ]
                    }
                }
            ]
flag_count_example = {}
list_server = []
error_code = ""
server_error = "" 

@client.event 
async def on_ready(): 
    print("We havbe logged in {0.user} user".format(client))

@client.event

async def on_message(message): 
    username = str(message.author)
    user_message = str(message.content)
    channel = str(message.channel) 
    server_error = ""
    error_code = ""
    
    if len(flag_count_example) > 0:
        server_error = ((list(flag_count_example.keys()))[0])
        error_code = ((list((flag_count_example[server_error]).keys()))[0])
        array_user_confirm = (flag_count_example[server_error][error_code][0])["Confirm"]
        array_user_denied = (flag_count_example[server_error][error_code][1])["Denied"]
            
    if username == "Powershell Hook#0000" and "e01" in user_message: #to be continue 
        array_char = user_message.split("-")
        error_code = (array_char[1])[1:-1]
        server_error = (array_char[0])[1:-1]
        list_server.append(server_error)
        print(list_server)
        flag_count_example[server_error] = {error_code:[{"Confirm":[]},{"Denied":[]}], "error_meesage":'{}'.format(user_message)}
        array_user_confirm = (flag_count_example[server_error][error_code][0])["Confirm"]
        array_user_denied = (flag_count_example[server_error][error_code][1])["Denied"]
        print(flag_count_example)
    
    if username in ["Duyne#0794", "Bi#6885"] and "/e01-Confirm" in user_message:
        server_input = user_message.split("-")
        error_code = (server_input[0])[1:]
        
        if server_input[-1] in flag_count_example:
            array_user_confirm = (flag_count_example[server_input[-1]][error_code][0])["Confirm"]
            array_user_denied = (flag_count_example[server_input[-1]][error_code][1])["Denied"]
            if username not in array_user_confirm and username not in array_user_denied:
                array_user_confirm.append(username)
                array_user_denied.append(username)
                await message.channel.send("Server {} is restarting. Please wait".format(server_input[-1]))
                subprocess.run(["powershell", "-Command", r"D:\Report_Daily\restart_script.ps1 {}.de.bosch.com".format(server_input[-1])])
                time.sleep(180)
                command = ['ping', "-n", '4', "{}.de.bosch.com".format(server_input[-1])]#format(server_error[1:-1])
                status_restart = subprocess.call(command)
                if status_restart == 0:
                    print("Before: " +str(flag_count_example))
                    await message.channel.send("@{} {}.de.bosch.com restart successfully.".format(array_user_confirm[0], server_input[-1]))
                    flag_count_example.pop(server_input[-1])
                    print("After: " + str(flag_count_example))
                    if len(flag_count_example) > 0:
                        await message.channel.send("There is {} more error need to action. Please proceed")
                
                elif status_restart == 1:
                    print("Before: " +str(flag_count_example))
                    await message.channel.send("@{} {}.de.bosch.com restart fail, please take action immediately".format(array_user_confirm[0], server_input[-1]))
                    flag_count_example.pop(server_input[-1])
                    print("After: " + str(flag_count_example))
                    if len(flag_count_example) > 0:
                        await message.channel.send("There is {} more error need to action. Please proceed")
            
            elif username in array_user_denied and username in array_user_confirm and ("/e01-Confirm-{}".format((server_input[0])[1:]) in user_message or "/e01-Denied-{}".format((server_input[0])[1:]) in user_message):
                await message.channel.send("{} has take control the error. Please wait for processing".format(username))
    
    elif username in ["Duyne#0794", "Bi#6885"] and "/e01-Denied-" in user_message:
        server_input = user_message.split("-")
        error_code = (server_input[0])[1:]
        array_user_confirm = (flag_count_example[server_input[-1]][error_code][0])["Confirm"]
        array_user_denied = (flag_count_example[server_input[-1]][error_code][1])["Denied"]
        if username not in array_user_confirm and username not in array_user_denied:
            array_user_confirm.append(username)
            array_user_denied.append(username)
            print("Before: " +str(flag_count_example))
            await message.channel.send("Cancel restart server. This error will be log in the Relay System for the future diagnose")
            flag_count_example.pop(server_input[-1])
            print("After: " + str(flag_count_example))
            if len(flag_count_example) > 0:
                await message.channel.send("There is {} more error need to action. Please proceed")
        
        elif username in array_user_denied and username in array_user_confirm and ("/e01-Confirm-{}".format((server_input[0])[1:]) in user_message or "/e01-Denied-{}".format((server_input[0])[1:]) in user_message):
            await message.channel.send("{} has take control the error. Please wait for processing".format(username))
    
    if username == "Powershell Hook#0000" and "Report Daily" in user_message:
        path = "D:/Report_Daily/alert_discord/"
        list_file = os.listdir(path)
        tabulate_report_1 = "\u001b[1;33mRoutine Test Check In/Out Report\033[0m\n" + report_1(list_file, path)
        tabulate_report_2 = "\u001b[1;33mvDog Checking/Recover Service Status\033[0m\n" + report_2(list_file, path)
        tabulate_report_3 = "\u001b[1;33mFree Space Disk Checking Status\033[0m\n" + report_3(list_file, path)
        await message.channel.send(f"```ansi\n{tabulate_report_1}\n```")
        await message.channel.send(f"```ansi\n{tabulate_report_2}\n```")
        await message.channel.send(f"```ansi\n{tabulate_report_3}\n```")
        time.sleep(5)
        list_file_png = count_file_exist(".png", list_file)
        for file_png in list_file_png:
            with open(r"D:\Report_Daily\alert_discord\{}".format(file_png),'rb') as fp:
                await message.channel.send(file=discord.File(fp,"{}.jpg".format(file_png[0:-4])))

def count_file_exist(pattern, list_file):
    no_file = 0
    list_count_file = []
    for name_file in list_file:
        if re.findall(pattern, name_file):
            no_file = no_file + 1
            list_count_file.append(name_file)
    return list_count_file

def report_1(list_file, path):
    list_file_report_1 = count_file_exist("report_1", list_file)
    column_name_report_1 = ["Host", "Service", "Status"]
    data = []
    for file_report_1 in list_file_report_1:
        data_dump = subprocess.run(["powershell", "-Command", "Get-Content {}{} | ConvertFrom-Json".format(path.replace("/","\\"),file_report_1)], capture_output=True)
        data_dump = str((data_dump.stdout).decode("UTF-8"))
        data_dump = json.loads(data_dump)
        status_checkin = data_dump["data"]["status"]["status_check_in"]
        status_checkout = data_dump["data"]["status"]["status_check_out"]
        server_report = data_dump["data"]["server"]
        data_check_status_check_in = []
        data_check_status_check_out = []
        if "fail" in status_checkin:
            data_check_status_check_in.append('\u001b[31m{}.de.bosch.comc'.format(server_report))
            data_check_status_check_in.append('\u001b[31m{}\033[0m'.format("Check In"))
            data_check_status_check_in.append('\u001b[31m{}\033[0m'.format(status_checkin))
        elif "successfully" in status_checkin:
            data_check_status_check_in.append('\u001b[36m{}.de.bosch.com\033[0m'.format(server_report))
            data_check_status_check_in.append('\u001b[36m{}\033[0m'.format("Check In"))
            data_check_status_check_in.append('\u001b[36m{}\033[0m'.format(status_checkin))
        elif "maintainance" in status_checkin:
            data_check_status_check_in.append('\u001b[33m{}.de.bosch.com\033[0m'.format(server_report))
            data_check_status_check_in.append('\u001b[33m{}\033[0m'.format("Check In"))
            data_check_status_check_in.append('\u001b[33m{}\033[0m'.format(status_checkin))
        elif "Database" in status_checkin:
            data_check_status_check_in.append('\u001b[33m{}.de.bosch.com\033[0m'.format(server_report))
            data_check_status_check_in.append('\u001b[33m{}\033[0m'.format("Check In"))
            data_check_status_check_in.append('\u001b[33m{}\033[0m'.format(status_checkin))
        elif "[no version backup created]" in status_checkin:    
            data_check_status_check_in.append('\u001b[31m{}.de.bosch.com\033[0m'.format(server_report))
            data_check_status_check_in.append('\u001b[31m{}\033[0m'.format("Check In"))
            data_check_status_check_in.append('\u001b[31m{}\033[0m'.format(status_checkin))
        
        if type(status_checkout) is type(None):
            data_check_status_check_out.append("\u001b[31m{}.de.bosch.com\033[0m".format(server_report))
            data_check_status_check_out.append("\u001b[31m{}\033[0m".format("Check Out"))
            data_check_status_check_out.append("\u001b[31m{}\033[0m".format("Check Out fail"))    
        elif "successfully" in status_checkout:
            data_check_status_check_out.append("\u001b[36m{}.de.bosch.com\033[0m".format(server_report))
            data_check_status_check_out.append("\u001b[36m{}\033[0m".format("Check Out"))
            data_check_status_check_out.append("\u001b[36m{}\033[0m".format(status_checkout))
        elif "fail" in status_checkout:
            data_check_status_check_out.append("\u001b[31m{}.de.bosch.com\033[0m".format(server_report))
            data_check_status_check_out.append("\u001b[31m{}\033[0m".format("Check Out"))
            data_check_status_check_out.append("\u001b[31m{}\033[0m".format(status_checkout))
        elif "maintainance" in status_checkout:
            data_check_status_check_out.append("\u001b[33m{}.de.bosch.com\033[0m".format(server_report))
            data_check_status_check_out.append("\u001b[33m{}\033[0m".format("Check Out"))
            data_check_status_check_out.append("\u001b[33m{}\033[0m".format(status_checkout))
        data.append(data_check_status_check_in)
        data.append(data_check_status_check_out)
    
    
    tabulate_report_1 = tabulate(data, headers=column_name_report_1, tablefmt="fancy_grid")
    return tabulate_report_1

def report_2(list_file, path):
    data = []
    list_file_report_2 = count_file_exist("report_2", list_file)
    column_name_report_2 = ["Host", "Service", "Status"]
    for file_report in list_file_report_2:
        data_dump = subprocess.run(["powershell","-Command","Get-Content {}{} | ConvertFrom-Json".format(path.replace("/","\\"),file_report)],capture_output=True)
        data_dump = str((data_dump.stdout).decode("UTF-8"))
        data_dump = json.loads(data_dump)
        service_name = data_dump["data"]["service"]["service_name"]
        service_status = data_dump["data"]["service"]["service_status"]
        server_report = data_dump["data"]["server"]
        list_service = []
        if service_status == "Stopped":
            list_service.append('\u001b[31m{}.de.bosch.com\033[0m'.format(server_report))
            list_service.append('\u001b[31m{}\033[0m'.format(service_name))
            list_service.append('\u001b[31m{}\033[0m'.format(service_status))
        elif service_status == "Running":
            list_service.append('\u001b[36m{}.de.bosch.com\033[0m'.format(server_report))
            list_service.append('\u001b[36m{}\033[0m'.format(service_name))
            list_service.append('\u001b[36m{}\033[0m'.format(service_status))
        data.append(list_service)
    tabulate_report_2 = tabulate(data, headers=column_name_report_2, tablefmt="fancy_grid")
    return tabulate_report_2

def report_3(list_file, path):
    data_report = []
    list_file_report_3 = count_file_exist("Disk_Utilization_", list_file)
    column_name_report_3 = []
    
    for file_report in list_file_report_3:
        list_disk = []
        data_dump = subprocess.run(["powershell","-Command","ConvertTo-Json -InputObject (Get-Content '{}{}' | ConvertFrom-Json) -Depth 5".format(path.replace("/","\\"),file_report)], capture_output=True)
        data_dump = str((data_dump.stdout.decode("UTF-8")))
        data_dump = json.loads(data_dump)
        server_report = data_dump["server_name"]
        list_disk.append('{}'.format(server_report))
        drive_list = data_dump['data']
        for drive in drive_list:
            if drive['drive'] not in column_name_report_3:
                column_name_report_3.append(drive['drive'])
        for data in data_dump["data"]:
            percent_free_space = round(((data["data_drive"][-1])["free"]/data["size"]*100),1)
            if(percent_free_space < 15):
                list_disk.append('\u001b[31m{}\033[0m'.format("{} % ({}GB / {}GB)".format(percent_free_space, (data["data_drive"][-1])["free"], data["size"] )))
                
            elif(percent_free_space >= 15):
                list_disk.append('\u001b[36m{}\033[0m'.format("{} % ({}GB / {}GB)".format(percent_free_space, (data["data_drive"][-1])["free"], data["size"] )))
        data_report.append(list_disk)
    tabulate_report_3 = tabulate(data_report, headers= column_name_report_3, tablefmt="fancy_grid")
    return tabulate_report_3

client.run(TOKEN)