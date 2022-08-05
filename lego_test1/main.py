#!/usr/bin/env pybricks-micropython
from pybricks.hubs import EV3Brick
from pybricks.ev3devices import (Motor, TouchSensor, ColorSensor,
                                 InfraredSensor, UltrasonicSensor, GyroSensor)
from pybricks.parameters import Port, Stop, Direction, Button, Color
from pybricks.tools import wait, StopWatch, DataLog
from pybricks.robotics import DriveBase
from pybricks.media.ev3dev import SoundFile, ImageFile
import threading
import time
import sys
# This program requires LEGO EV3 MicroPython v2.0 or higher.
# Click "Open user guide" on the EV3 extension tab for more information.


# Create your objects here.

ev3 = EV3Brick()
motor = Motor(Port.A)
# right_motor = motorB
# robot = DriveBase(left_motor, right_motor, wheel_diameter=55, axle_track=152)
# robot.settings(straight_speed=200, straight_acceleration=150, turn_rate=0)
SPEED_DEFAULT = 700
# try:
#     obstacle_sensor = UltrasonicSensor(Port.S1)
# except:
# def check_sensor():
while True:
    a = True
    b = True
    c = True
    d = True
    try:
        obstacle_sensor = UltrasonicSensor(Port.S1)
        motor.run(speed = 0)
        break
    except Exception as e:
        a = False
        time.sleep(2)        
    try:
        obstacle_sensor = UltrasonicSensor(Port.S2)
        motor.run(speed = 0)
        break
    except Exception as e:
        b = False
        time.sleep(2)
        
    try:
        obstacle_sensor = UltrasonicSensor(Port.S3)
        motor.run(speed = 0)
        break
    except Exception as e:
        c = False
        time.sleep(2)
        
    try:
        obstacle_sensor = UltrasonicSensor(Port.S4)
        motor.run(speed = 0)
        break
    except Exception as e:
        d = False
        time.sleep(2)
    if a == True and b == True and c == True and d == True:
        break
    else:
        ev3.speaker.beep(frequency=500, duration = 100)
        ev3.screen.print("Ultrasonic Sensor is not connected. Please check again")
        
        
    
while True:
    a = round(obstacle_sensor.distance())
    if a < 210:
        time_decrease = (3 - (12 * 3 / 15)) /3
        #speed_decrease = 500 - round((a - 3) * left_motor.speed()/a)
        speed_decrease = SPEED_DEFAULT - (SPEED_DEFAULT * (12 * 3 / 15) /3)
        #Calculate Speed
        ev3.screen.print("MEB activate")
        #Beeping Alert(1 score)
        ev3.speaker.beep(frequency=500, duration = 100)
        #Alert light on
        ev3.light.on(Color.RED) 
        #Print screen activate ( 1 score)
        #Slow down smoothly (1 point)
        speed_decrease = motor.speed() - round((a - 3) * motor.speed()/a) 
        ev3.screen.print(speed_decrease)
        while motor.speed() > 0:
            b = round(obstacle_sensor.distance())
            if b < 70:
                motor.run(speed = 10)
                motor.run(speed = 0)
                break 
            else:
                motor.run(speed = motor.speed() - speed_decrease)
                if motor.speed() - speed_decrease < 0:
                    time.sleep(0.43)
                    motor.run(speed = motor.speed() - motor.speed())
                    break
                time.sleep(time_decrease)
        c = round(obstacle_sensor.distance())   
        ev3.light.off()
        ev3.screen.print(c)
    elif a > 210:
        motor.run(speed = SPEED_DEFAULT)
    