#!/usr/bin/python
import sys
import time
import os
import Adafruit_DHT
import automationhat

temp_id = 1
hum_id = 2
soil_id = 11
username = os.environ['AUTH_USERNAME']
password = os.environ['AUTH_PASSWORD']
dht_pin = 8

# set to Adafruit_DHT.DHT11, Adafruit_DHT.DHT22, or Adafruit_DHT.AM2302
sensor = Adafruit_DHT.DHT22

# setup pimoroni
#automationhat.light.comms.toggle()
#automationhat.light.warn.toggle()
#automationhat.light.power.write(1)
#automationhat.output.two.on()
#automationhat.output.one.on()

def remap_range(value, left_min, left_max, right_min, right_max):
    # this remaps a value from original (left) range to new (right) range
    # Figure out how 'wide' each range is
    left_span = left_max - left_min
    right_span = right_max - right_min
 
    # Convert the left range into a 0-1 range (int)
    valueScaled = int(value - left_min) / int(left_span)
 
    # Convert the 0-1 range into a value in the right range.
    return int(right_min + (valueScaled * right_span))

def water():
    print "turning on water pump ..."
    print "./turn_air_quality_pump_on.sh"
    os.system("./turn_air_quality_pump_on.sh")

    time.sleep(30)

    print "turning off water pump ..."
    print "./turn_air_quality_pump_off.sh"
    os.system("./turn_air_quality_pump_off.sh")

while True:
    # read soil moisture
    #moisture = automationhat.analog.one.read()
    #print 'Soil Moisture value: {0:0.1f}'.format(moisture)
    #if moisture > 0:
    #    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture*100), username, password, soil_id)
    #    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture*100), username, password, soil_id))

    #if moisture > 2:
    #    water()

    # read temp/humidity sensor
    humidity, temperature = Adafruit_DHT.read_retry(sensor, dht_pin)
    temperature = temperature - 3
    print 'Temp: {0:0.1f}C,  Humidity: {1:0.1f}%'.format(temperature, humidity)
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id))
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id))
    time.sleep(600)
