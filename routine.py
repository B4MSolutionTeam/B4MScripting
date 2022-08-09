# import subprocess

# def check_out_function():
#     check_out = subprocess.check_output('"D:\vdClient\VDogAutoCheckOut.exe" /rd:d:\vdCA /at:c /dirR:\Ba\HDEV6\test\Json /CID:79A125F135C24D4892C657D1F1A20722 /Account:Versiondog /Password:changeit')

# def check_in_fucntion():
#     check_in = subprocess.check_output('"D:\vdClient\VDogAutoCheckIn.exe" /RD:D:\vdCA /AT:C /CFile:D:\AutoCheckIn.ini /Password:changeit /Account:Versiondog')
#     if len(str(check_in)) > 0:
#         status = (str(check_in)).split(" ")
#         print("There is error appear when the program is running, please check again")
import PyInstaller.__main__
PyInstaller.__main__.run([
    'duplicate_version.py',
    '--onefile',
    '--windowed'
])