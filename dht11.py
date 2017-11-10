#!/usr/bin/python
import sys
import time
import os
import Adafruit_DHT

temp_id = 25
hum_id = 22
username = os.environ['WEATHERAPI_USERNAME']
password = os.environ['WEATHERAPI_PASSWORD']

while True:
    humidity, temperature = Adafruit_DHT.read_retry(11, 4)
    print 'Temp: {0:0.1f}C,  Humidity: {1:0.1f}%'.format(temperature, humidity)
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://weatherapp.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://weatherapp.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id))
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://weatherapp.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://weatherapp.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id))
    time.sleep(120)
