import csv
import subprocess
import json
import PyInstaller.__main__

PyInstaller.__main__.run([
    'CPU_RAM_Disk.py',
    '--onefile',
    '--windowed'
])
