#!/usr/bin/python
import sys
import time
import os
import Adafruit_DHT

temp_id = 1
hum_id = 2
username = os.environ['AUTH_USERNAME']
password = os.environ['AUTH_PASSWORD']
dht_pin = 4

# set to Adafruit_DHT.DHT11, Adafruit_DHT.DHT22, or Adafruit_DHT.AM2302
sensor = Adafruit_DHT.DHT22

while True:
    humidity, temperature = Adafruit_DHT.read_retry(sensor, dht_pin)
    print 'Temp: {0:0.1f}C,  Humidity: {1:0.1f}%'.format(temperature, humidity)
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id))
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id))
    time.sleep(500)
