#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'python3 living_room.py' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    python3 living_room.py &
fi
