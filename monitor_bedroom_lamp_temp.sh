#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'report_bedroom_lamp_temp.sh' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    ./report_bedroom_lamp_temp.sh &
fi
