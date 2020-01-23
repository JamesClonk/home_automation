#!/bin/bash

cd /root/home_automation/

ping -c4 192.168.1.1 > /dev/null
 
if [ $? != 0 ] 
then
    #/sbin/shutdown -r now
    echo "No network connection, restarting wlan0"
    /sbin/ifdown 'wlan0'
    sleep 10
    /sbin/ifup --force 'wlan0'
fi

