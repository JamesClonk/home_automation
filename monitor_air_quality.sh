#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'python air_quality.py' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    python air_quality.py &
fi
