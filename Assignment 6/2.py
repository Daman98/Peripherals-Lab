import RPi.GPIO as gpio
import time

gpio.setmode(gpio.BCM)

#Initializing gpio pins
CRO = 24

freq = 40

gpio.setup(CRO, gpio.OUT)

gpio.output(CRO, False)

# setup the raspi board
time.sleep(1)

#PWM signal going out from pin CRO at frequency freq. This output is saved in p
p = gpio.PWM(CRO,  freq)
p.start(0)

#This loop will take input for duty cycle and will change it accordingly. Whenever a keyboard interrupt is give program ends.
try:
    while(1):
    	dc=input()
        p.ChangeDutyCycle(dc)
        time.sleep(0.1)

except KeyboardInterrupt:
        pass

p.stop()

gpio.cleanup()
