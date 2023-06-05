import base64
import os
import csv
from email.mime.text import MIMEText
import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders
from email.mime.application import MIMEApplication
path = "C:/vdSA/Report_Daily/"
list_server = []
with open(path+"VertexSplunkURL.csv", 'r') as f:
    csvreader = csv.reader(f)
    csvreader = list(csvreader)
    list_server = csvreader[1:]
    f.close()

table = """
"""
json_string = {}
for png in os.listdir(path):
    if ".png" in png:
        png_name = png.split(".")
        for server in list_server:
            if str(png_name[0]).upper() == str(server[1]).upper():
                if server[0] not in json_string:
                    json_string[server[0]] = []
                    json_string[server[0]].append(png)
                else:
                    json_string[server[0]].append(png)
for i in json_string:
    table = table + """
                <tr>
                <td>{}</td>
                <td>
                <ul>
                """.format(i)
    for j in json_string[i]:
        with open(path + j,'rb') as png_picture:
                    encode_string = base64.b64encode(png_picture.read())
                    encode_string = encode_string.decode('utf-8')
        table = table + """
        <li><img src="data:image/png;base64,{}"/></li>
        """.format(encode_string,encode_string)
    table = table + """
    </ul>
    </td>
    </tr>"""
    png_picture.close()
style = """
<style>
            table, th, td {
                border: 1px solid black;
                font-size: 110%
            }
            li{
                list-style: none;
            }
            </style>"""
message = """
<html>
    <head>
        {}
    </head>
<body>
    <table>
    <tr>
        <th>&nbsp;</th>
        <th>Grahps</th>
    </tr>
    {}
    </table>
</body>
<html>
""".format(style,table)

f = open("demo.html",'a')
f.write(message)
attachment_path = []
def send_mail_total(SUBJECT ,MESSAGE, attachment_path):
    #hc1_ci_b4m_operationproject@bcn.bosch.com
    recipent = ["Duy.TaThai@vn.bosch.com"]
    msg = MIMEMultipart()
    msg['Subject'] = SUBJECT 
    msg['From'] = "Duy.TaThai@vn.bosch.com"
    msg['To'] = ", ".join(recipent)

    part = MIMEBase('application', "octet-stream")
    
    if len(attachment_path) > 0:
        for f in attachment_path:
            file_path = os.path.join("",f)
            print(file_path)
            attachment = MIMEApplication(open(file_path, "rb").read(), _subtype="csv")
            attachment.add_header('Content-Disposition','attachment', filename=(f.split("/"))[-1])
            msg.attach(attachment)
    msg.attach(MIMEText(MESSAGE, 'html'))
         
    # else:
    #     msg.attach(MIMEText(MESSAGE, 'plain'))

    server = smtplib.SMTP("rb-smtp-auth.rbesz01.com")
    server.ehlo()
    server.starttls()
    server.ehlo()
    server.login("tad6hc@bosch.com", "Haha050399@@")
    server.sendmail("Duy.TaThai@vn.bosch.com","Duy.TaThai@vn.bosch.com", msg.as_string())
send_mail_total("dadsd", message, attachment_path)
# print(message)