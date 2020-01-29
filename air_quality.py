#!/usr/bin/python
import sys
import time
import os
import Adafruit_DHT
import automationhat

temp_id = 1
hum_id = 2
soil_id_one = 11
soil_id_two = 14
username = os.environ['AUTH_USERNAME']
password = os.environ['AUTH_PASSWORD']
dht_pin = 8

# set to Adafruit_DHT.DHT11, Adafruit_DHT.DHT22, or Adafruit_DHT.AM2302
sensor = Adafruit_DHT.DHT22

# setup pimoroni
automationhat.light.comms.toggle()
automationhat.light.warn.toggle()
automationhat.light.power.write(1)
#automationhat.output.three.on()
automationhat.output.two.on()
automationhat.output.one.on()

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

def water():
    print "turning on water pump ..."
    print "./turn_air_quality_pump_on.sh"
    os.system("./turn_air_quality_pump_on.sh")

    time.sleep(30)

    print "turning off water pump ..."
    print "./turn_air_quality_pump_off.sh"
    os.system("./turn_air_quality_pump_off.sh")

def read_soil():
    # read soil moisture
    moisture_one = automationhat.analog.one.read()
    moisture_two = automationhat.analog.two.read()
    #moisture_three = automationhat.analog.three.read()

    print 'Air Quality Plants - Soil Moisture values: {0:0.3f}, {1:0.3f}'.format(moisture_one, moisture_two)
    moisture_one = cut(map(moisture_one, 1.14, 1.3, 100, 0), 0, 100)
    moisture_two = cut(map(moisture_two, 1.4, 2.3, 100, 0), 0, 100)
    print 'Air Quality Plants - Remapped values: {0:0.3f}, {1:0.3f}'.format(moisture_one, moisture_two)
    return moisture_one, moisture_two

while True:
    # read soil moisture
    moisture_one, moisture_two = read_soil()
    if moisture_one <= 1 or moisture_two <= 1:
        # reread
        time.sleep(2)
        moisture_one, moisture_two = read_soil()

    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_one), username, password, soil_id_one)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_one), username, password, soil_id_one))
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_two), username, password, soil_id_two)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_two), username, password, soil_id_two))
    if moisture_one < 25:
        water()

    # read temp/humidity sensor
    humidity, temperature = Adafruit_DHT.read_retry(sensor, dht_pin)
    print 'Temp: {0:0.1f}C,  Humidity: {1:0.1f}%'.format(temperature, humidity)
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id))
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id))
    time.sleep(300)
