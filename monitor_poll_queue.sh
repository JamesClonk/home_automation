#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'python poll_queue.py' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    python poll_queue.py &
fi
