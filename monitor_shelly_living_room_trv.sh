#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'report_shelly_living_room_trv.sh' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    ./report_shelly_living_room_trv.sh &
fi