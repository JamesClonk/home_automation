#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'python living_room.py' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    python living_room.py &
fi
