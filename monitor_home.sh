#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'python dht22.py' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    export AUTH_USERNAME=xyz
    export AUTH_PASSWORD=abc
    python dht22.py &
fi
