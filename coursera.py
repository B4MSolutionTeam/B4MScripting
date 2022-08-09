
import subprocess

p = subprocess.check_output("powershell -file C:/vdServerAchieve/sendmail.ps1", shell = True)
print(p)