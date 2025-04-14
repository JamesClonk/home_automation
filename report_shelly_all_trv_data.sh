#!/bin/bash

SHELLY_DEVICE_ID=34cdb078bc64
SENSOR_POS_ID=32
SENSOR_BAT_ID=42

while true; do
  export SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}")
  echo ${SHELLY_DATA} | jq -r '.data.device_status'

  sleep 777
done

