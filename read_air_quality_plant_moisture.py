#!/usr/bin/python
import sys
import time
import os
import automationhat
time.sleep(1)

# setup pimoroni
automationhat.enable_auto_lights(False)
automationhat.analog.one.auto_light(False)
automationhat.analog.two.auto_light(False)
automationhat.analog.one.light.off()
automationhat.analog.two.light.off()
automationhat.light.comms.off()
automationhat.light.warn.off()
automationhat.light.power.off()
time.sleep(1)
automationhat.output.one.on()
automationhat.output.two.on()
time.sleep(2) # let it settle

def map(value, leftMin, leftMax, rightMin, rightMax):
    leftSpan = leftMax - leftMin
    rightSpan = rightMax - rightMin
    valueScaled = float(value - leftMin) / float(leftSpan)
    return rightMin + (valueScaled * rightSpan)

def cut(value, minValue, maxValue):
    if value < minValue:
        return minValue
    if value > maxValue:
        return maxValue
    return value

def read_soil():
    # read soil moisture
    moisture_one = automationhat.analog.one.read()
    moisture_two = automationhat.analog.two.read()
    #moisture_three = automationhat.analog.three.read()

    print('Air Quality Plants - Soil Moisture values: {0:0.3f}, {1:0.3f}'.format(moisture_one, moisture_two))
    moisture_one = cut(map(moisture_one, 1.6, 3.4, 100, 0), 0, 100)
    moisture_two = cut(map(moisture_two, 1.4, 3.1, 100, 0), 0, 100)
    print('Air Quality Plants - Remapped values: {0:0.3f}, {1:0.3f}'.format(moisture_one, moisture_two))
    return moisture_one, moisture_two

while True:
    # read soil moisture
    moisture_one, moisture_two = read_soil()
    time.sleep(2)
