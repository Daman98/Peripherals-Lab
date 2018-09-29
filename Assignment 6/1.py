import RPi.GPIO as gpio
import time


    
gpio.setmode(gpio.BCM)

#Initializing gpio pins
A_Pin = 24
B_Pin = 25
C_Pin = 26
D_Pin = 13
E_Pin = 5

#Output Pins
gpio.setup(A_Pin, gpio.OUT)
gpio.setup(B_Pin, gpio.OUT)

#Input Pins
gpio.setup(C_Pin, gpio.IN)
gpio.setup(D_Pin, gpio.IN)
gpio.setup(E_Pin, gpio.IN)

gpio.output(A_Pin, False)
gpio.output(B_Pin, False)

# setup the raspi board
time.sleep(1)

Sel_C = gpio.input(C_Pin)
Sel_D = gpio.input(D_Pin)
Sel_E = gpio.input(E_Pin)

TimePeriod = 0.1

# While C is High nothing will happen
while(Sel_C!=0):
    Sel_C = gpio.input(C_Pin)

print "C is Low Now"

# When C becomes low A and B LEDs will start glowing alternately
while(Sel_D!=1):   
    gpio.output(A_Pin, True)
    gpio.output(B_Pin, False)
    time.sleep(TimePeriod)

    gpio.output(A_Pin, False)
    gpio.output(B_Pin, True)
    time.sleep(TimePeriod)
    Sel_D = gpio.input(D_Pin)

print "D is High Now"

# When D becomes high Time period becomes half so that frequency of blinking becomes double
time.sleep(1)
TimePeriod = TimePeriod/2

while(Sel_E!=0):
    gpio.output(A_Pin, True)
    gpio.output(B_Pin, False)
    time.sleep(TimePeriod)

    gpio.output(A_Pin, False)
    gpio.output(B_Pin, True)
    time.sleep(TimePeriod)
    Sel_E = gpio.input(E_Pin)

print "E is Low Now"
# When E becomes low both LEDs will glow for 5 secs and then turned off as program is finished
time.sleep(1)

gpio.output(A_Pin, True)
gpio.output(B_Pin, True)

time.sleep(5)
gpio.cleanup()



