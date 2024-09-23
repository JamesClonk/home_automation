#!/usr/bin/python
import sys
import time
import os
import urllib2
import base64
import json

username = os.environ['AUTH_USERNAME']
password = os.environ['AUTH_PASSWORD']

def get_messages():
    request = urllib2.Request("https://home-info.jamesclonk.io/messages")
    base64string = base64.b64encode('%s:%s' % (username, password))
    request.add_header("Authorization", "Basic %s" % base64string)   
    result = json.load(urllib2.urlopen(request))
    return result

def delete_message(id):
    request = urllib2.Request("https://home-info.jamesclonk.io/message/{0}".format(id))
    base64string = base64.b64encode('%s:%s' % (username, password))
    request.add_header("Authorization", "Basic %s" % base64string)   
    request.get_method = lambda: 'DELETE'
    response = urllib2.urlopen(request)
    return response.getcode() == 204

def water():
    print "trigger water pump cycle ..."
    print "./trigger_water_pump_cycle.sh"
    os.system("./trigger_water_pump_cycle.sh")
    time.sleep(5) # wait

def poll():
    # query messages
    messages = get_messages()
    for message in messages:   
        print message
        if message["queue"] == "air_quality_light":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./turn_air_quality_lamp_on.sh"
                os.system("./turn_air_quality_lamp_on.sh")
            if message["message"] == "off" and delete_message(message["id"]):
                print "./turn_air_quality_lamp_off.sh"
                os.system("./turn_air_quality_lamp_off.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./toggle_air_quality_lamp.sh"
                os.system("./toggle_air_quality_lamp.sh")
        if message["queue"] == "plant_room_fan":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./turn_plant_room_fan_on.sh"
                os.system("./turn_plant_room_fan_on.sh")
            if message["message"] == "off" and delete_message(message["id"]):
                print "./turn_plant_room_fan_off.sh"
                os.system("./turn_plant_room_fan_off.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./toggle_plant_room_fan.sh"
                os.system("./toggle_plant_room_fan.sh")
        if message["queue"] == "plant_room_light":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./turn_plant_room_lamp_on.sh"
                os.system("./turn_plant_room_lamp_on.sh")
            if message["message"] == "off" and delete_message(message["id"]):
                print "./turn_plant_room_lamp_off.sh"
                os.system("./turn_plant_room_lamp_off.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./toggle_plant_room_lamp.sh"
                os.system("./toggle_plant_room_lamp.sh")
        if message["queue"] == "food_plants_fan":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./turn_food_plants_fan_on.sh"
                os.system("./turn_food_plants_fan_on.sh")
            if message["message"] == "off" and delete_message(message["id"]):
                print "./turn_food_plants_fan_off.sh"
                os.system("./turn_food_plants_fan_off.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./toggle_food_plants_fan.sh"
                os.system("./toggle_food_plants_fan.sh")
        if message["queue"] == "food_plants_light":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./turn_food_plants_lamp_on.sh"
                os.system("./turn_food_plants_lamp_on.sh")
            if message["message"] == "off" and delete_message(message["id"]):
                print "./turn_food_plants_lamp_off.sh"
                os.system("./turn_food_plants_lamp_off.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./toggle_food_plants_lamp.sh"
                os.system("./toggle_food_plants_lamp.sh")
        if message["queue"] == "food_plants_water_pump_cycle":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./trigger_water_pump_cycle.sh"
                os.system("./trigger_water_pump_cycle.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./trigger_water_pump_cycle.sh"
                os.system("./trigger_water_pump_cycle.sh")
        if message["queue"] == "food_plants_water_pump_single_burst":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./trigger_water_pump_single_burst.sh"
                os.system("./trigger_water_pump_single_burst.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./trigger_water_pump_single_burst.sh"
                os.system("./trigger_water_pump_single_burst.sh")
        if message["queue"] == "herb_garden_light":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./turn_herb_garden_lamp_on.sh"
                os.system("./turn_herb_garden_lamp_on.sh")
            if message["message"] == "off" and delete_message(message["id"]):
                print "./turn_herb_garden_lamp_off.sh"
                os.system("./turn_herb_garden_lamp_off.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./toggle_herb_garden_lamp.sh"
                os.system("./toggle_herb_garden_lamp.sh")
        if message["queue"] == "bedroom_light":
            if message["message"] == "on" and delete_message(message["id"]):
                print "./turn_bedroom_lamp_on.sh"
                os.system("./turn_bedroom_lamp_on.sh")
            if message["message"] == "off" and delete_message(message["id"]):
                print "./turn_bedroom_lamp_off.sh"
                os.system("./turn_bedroom_lamp_off.sh")
            if message["message"] == "toggle" and delete_message(message["id"]):
                print "./toggle_bedroom_lamp.sh"
                os.system("./toggle_bedroom_lamp.sh")

while True:
    poll()
    time.sleep(10)

