#!/bin/bash

cd /root/home_automation/

running=`ps -ef | grep 'report_shelly_bedroom_ht.sh' | grep -v 'grep' | wc -l`

if [ "$running" -eq "0" ]
then
    ./report_shelly_bedroom_ht.sh &
fi