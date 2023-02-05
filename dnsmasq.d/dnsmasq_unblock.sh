#!/bin/bash

cd /root/home_automation/dnsmasq.d/
cp empty-hosts /etc/home_automation/addn-hosts
pkill -SIGHUP dnsmasq

