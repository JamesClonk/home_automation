#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'python bedroom.py' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    python bedroom.py &
fi
