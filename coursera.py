import PyInstaller.__main__

PyInstaller.__main__.run([
    'duplicate_version.py',
    '--onefile',
    '--windowed'
])

# from email.mime.text import MIMEText
# import smtplib
# from email.mime.multipart import MIMEMultipart
# from email.mime.base import MIMEBase
# from email import encoders


# SUBJECT = "Backup Version Overdate 10 year"
# recipent = ["an.phamnhat@vn.bosch.com", "vu.nguyenhoanganh@vn.bosch.com"]
# msg = MIMEMultipart()
# msg['Subject'] = SUBJECT 
# msg['From'] = "Duy.TaThai@vn.bosch.com"
# msg['To'] = ", ".join(recipent)

# part = MIMEBase('application', "octet-stream")
# part.set_payload(open("C:/vdSA/report.csv", "rb").read())
# encoders.encode_base64(part)
# part.add_header('Content-Disposition', 'attachment; filename="report.csv"')

# msg.attach(MIMEText("Hello, after examine all file backup version, we have discovered these files are overdate. Please kindly review and delete these files. Thank you", 'plain'))
# msg.attach(part)

# server = smtplib.SMTP("rb-smtp-int.bosch.com")
# server.sendmail("Duy.TaThai@vn.bosch.com","an.phamnhat@vn.bosch.com", msg.as_string())