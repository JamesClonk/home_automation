#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'report_co2_sensor.sh' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    ./report_co2_sensor.sh &
fi
