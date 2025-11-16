#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'report_obloc_occupancy.sh' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    ./report_obloc_occupancy.sh &
fi
