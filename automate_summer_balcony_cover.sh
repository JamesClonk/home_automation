#!/bin/bash
set -euo pipefail

cd /root/home_automation/

SHELLY_AWNING_DEVICE_ID=a0a3b3b97a28
WIND_SPEED_SENSOR_URL="https://home-info.jamesclonk.io/sensor/28/values/1"
TEMP_SENSOR_URL="https://home-info.jamesclonk.io/sensor/3/values/1"
RAIN_MM_SENSOR_URL="https://home-info.jamesclonk.io/sensor/99/values/1"

export CURRENT_WIND_SPEED=$(curl -s ${WIND_SPEED_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
export CURRENT_RAIN_MM=$(curl -s ${RAIN_MM_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
export CURRENT_TEMP=$(curl -s ${TEMP_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
echo "Current wind speed: ${CURRENT_WIND_SPEED} m/s"
echo "Current rain: ${CURRENT_RAIN_MM} mm"
echo "Current temperature: ${CURRENT_TEMP} °C"

export CURRENT_MONTH=$(date "+%m" | awk '{print int($1);}')
echo "Current month: ${CURRENT_MONTH}"

if (( ${CURRENT_WIND_SPEED} < 4 )); then
  if (( ${CURRENT_RAIN_MM} == 0 )); then
    if (( ${CURRENT_MONTH} > 4 )); then
      if (( ${CURRENT_MONTH} < 10 )); then
        if (( ${CURRENT_TEMP} > 23 )); then
          echo "its summer time, extend the awning to block out the heat ..."
          # dont go lower than 33%, otherwise the awing collides with the raised garden beds
          curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_AWNING_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=33" 
          sleep 5
        fi
      fi
    fi
  fi
fi

