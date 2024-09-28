#!/usr/bin/python
import sys
import time
import os
import Adafruit_DHT
time.sleep(1)

temp_id = 1
hum_id = 2
username = os.environ['AUTH_USERNAME']
password = os.environ['AUTH_PASSWORD']
dht_pin = 8

# set to Adafruit_DHT.DHT11, Adafruit_DHT.DHT22, or Adafruit_DHT.AM2302
sensor = Adafruit_DHT.DHT22
time.sleep(1)

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

def update():
    # read temp/humidity sensor
    humidity, temperature = Adafruit_DHT.read_retry(sensor, dht_pin)
    print('Temp: {0:0.1f}C,  Humidity: {1:0.1f}%'.format(temperature, humidity))
    print("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.jamesclonk.io/sensor/{3}/value".format(int(temperature), username, password, temp_id))
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.jamesclonk.io/sensor/{3}/value".format(int(temperature), username, password, temp_id))
    print("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.jamesclonk.io/sensor/{3}/value".format(int(humidity), username, password, hum_id))
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.jamesclonk.io/sensor/{3}/value".format(int(humidity), username, password, hum_id))
    
update()

