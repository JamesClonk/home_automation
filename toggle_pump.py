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
automationhat.relay.one.off()
time.sleep(2) # let it settle

while True:
    #automationhat.relay.one.toggle()
    automationhat.relay.one.on()
    time.sleep(1)
    automationhat.relay.one.off()
    time.sleep(5)
