#!/usr/bin/python
import sys
import time
import os
import Adafruit_DHT
import automationhat

temp_id = 1
hum_id = 2
soil_id_one = 10
soil_id_two = 12
soil_id_three = 13 # used for an additional air quality plant
username = os.environ['AUTH_USERNAME']
password = os.environ['AUTH_PASSWORD']
dht_pin = 8

# set to Adafruit_DHT.DHT11, Adafruit_DHT.DHT22, or Adafruit_DHT.AM2302
sensor = Adafruit_DHT.DHT22

# setup pimoroni
#automationhat.light.comms.toggle()
#automationhat.light.warn.toggle()
automationhat.light.power.write(1)
automationhat.output.three.on()
automationhat.output.two.on()
automationhat.output.one.on()

def water():
    print "turning on water pump ..."
    print "./turn_food_plants_pump_on.sh"
    os.system("./turn_food_plants_pump_on.sh")

    time.sleep(30)

    print "turning off water pump ..."
    print "./turn_food_plants_pump_off.sh"
    os.system("./turn_food_plants_pump_off.sh")

while True:
    # read soil moisture
    moisture_one = automationhat.analog.one.read()
    moisture_two = automationhat.analog.two.read()
    moisture_three = automationhat.analog.three.read()

    print 'Air Quality Plant - Soil Moisture value: {0:0.1f}'.format(moisture_three)
    if moisture_three > 0:
        print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_three*100), username, password, soil_id_three)
        os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_three*100), username, password, soil_id_three))

    print 'Food Plants - Soil Moisture values: {0:0.1f}, {0:0.1f}'.format(moisture_one, moisture_two)
    if moisture_one > 0 and moisture_two > 0:
        print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_one*100), username, password, soil_id_one)
        os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_one*100), username, password, soil_id_one))
        print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_two*100), username, password, soil_id_two)
        os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(moisture_two*100), username, password, soil_id_two))
    if moisture_one > 2 or moisture_two > 2:
        water()

    # read temp/humidity sensor
    humidity, temperature = Adafruit_DHT.read_retry(sensor, dht_pin)
    print 'Temp: {0:0.1f}C,  Humidity: {1:0.1f}%'.format(temperature, humidity)
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(temperature), username, password, temp_id))
    print "curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id)
    os.system("curl -X POST -d 'value={0:0d}' -u {1}:{2} https://home-info.scapp.io/sensor/{3}/value".format(int(humidity), username, password, hum_id))
    time.sleep(300)
