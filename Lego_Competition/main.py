import threading
from traceback import print_tb
import time

def decress_speed(motorA, motorB):
    while(motorA > 0 and motorB > 0):
        motorA = motorA - 1
        motorB = motorB - 1
        print(motorA," ", motorB)
        time.sleep(1)

t1 = threading.Thread(target=decress_speed,args=(100,100))
t1.start()