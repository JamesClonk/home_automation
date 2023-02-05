#!/bin/bash

cd /root/home_automation/dnsmasq.d/
cp addn-hosts /etc/home_automation/addn-hosts
pkill -SIGHUP dnsmasq

