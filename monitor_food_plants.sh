#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'python food_plants.py' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    python food_plants.py &
fi
