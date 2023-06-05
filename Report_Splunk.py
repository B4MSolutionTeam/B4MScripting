from dis import dis
import psutil, sys
from time import sleep
import subprocess
while True:
    cpu_percent = psutil.cpu_percent()
    physical_memory_percent = psutil.virtual_memory().percent
    virtual_memory_percent = psutil.swap_memory().percent
    total = psutil.virtual_memory().total
    pagefile_current = subprocess.run(['powershell', '-Command','(Get-CimInstance -ClassName Win32_PageFileUsage | Select-Object -Property CurrentUsage).CurrentUsage'], capture_output=True)
    pagefile_total = subprocess.run(['powershell','-Command','(Get-CimInstance -ClassName Win32_PageFileUsage | Select-Object -Property AllocatedBaseSize).AllocatedBaseSize'], capture_output=True)
    pagefile_current = int((pagefile_current.stdout).decode("utf-8"))
    pagefile_total = int((pagefile_total.stdout).decode("utf-8"))
    disk_instance = psutil.disk_partitions()
    if len(disk_instance) > 0:
        for disk_partitions in disk_instance:
            drive_name = disk_partitions.device
            disk_utilization = subprocess.run(['powershell', '-Command', '(Get-WMIObject -Class "Win32_PerfFormattedData_PerfDisk_PhysicalDisk" -Filter '+'''Name = '''+ drive_name +')'+'.PercentDiskTime'.format(drive_name)], capture_output=True)
            print("Disk Utilization: "+ (disk_utilization.stdout).decode('utf-8')+"%")
    print("CPU Percent: "+str(cpu_percent)+"%")
    print("Physical Memory Percent: "+str(physical_memory_percent)+"%" )
    # print("Viriual Memory Percent: "+ str(virtual_memory_percent)+"%")
    print("Page file Usage: "+str(round((pagefile_current/pagefile_total)*100,1))+"%")
    # print("Disk percent: "+str(disk_percentage)+"%")
    
    sleep(2)

