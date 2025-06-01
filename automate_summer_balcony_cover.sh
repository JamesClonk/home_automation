#!/bin/bash
set -euo pipefail

cd /root/home_automation/

SHELLY_AWNING_DEVICE_ID=a0a3b3b97a28
WIND_SPEED_SENSOR_URL="https://home-info.jamesclonk.io/sensor/28/values/1"
TEMP_SENSOR_URL="https://home-info.jamesclonk.io/sensor/3/values/1"
HUM_SENSOR_URL="https://home-info.jamesclonk.io/sensor/27/values/1"
RAIN_MM_SENSOR_URL="https://home-info.jamesclonk.io/sensor/51/values/1"

export CURRENT_WIND_SPEED=$(curl -s ${WIND_SPEED_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
export CURRENT_RAIN_MM=$(curl -s ${RAIN_MM_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
export CURRENT_TEMP=$(curl -s ${TEMP_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
export CURRENT_HUMIDITY=$(curl -s ${HUM_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
echo "Current wind speed: ${CURRENT_WIND_SPEED} m/s"
echo "Current rain: ${CURRENT_RAIN_MM} mm"
echo "Current temperature: ${CURRENT_TEMP} °C"
echo "Current humidity: ${CURRENT_HUMIDITY} %"

export CURRENT_MONTH=$(date "+%m" | awk '{print int($1);}')
echo "Current month: ${CURRENT_MONTH}"
export CURRENT_HOUR=$(date "+%H" | awk '{print int($1);}')
echo "Current hour: ${CURRENT_HOUR}"

function set_awning {
  TARGET_VALUE=$1
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_AWNING_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos' | awk '{print int($1);}')
  sleep 5
  if (( ${SHELLY_DATA} != $TARGET_VALUE )); then
    curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_AWNING_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=${TARGET_VALUE}"
    sleep 5
  fi
}

# safety checks for bad weather, dont extend awning if it rains / is windy / etc..
if (( ${CURRENT_WIND_SPEED} > 3 )); then
  set_awning 100
  exit 0
fi
if (( ${CURRENT_RAIN_MM} != 0 )); then
  set_awning 100
  exit 0
fi
if (( ${CURRENT_TEMP} <= 23 )); then
  set_awning 100
  exit 0
fi
if (( ${CURRENT_HUMIDITY} >= 93 )); then
  set_awning 100
  exit 0
fi
if (( ${CURRENT_MONTH} < 5 )); then
  set_awning 100
  exit 0
fi
if (( ${CURRENT_MONTH} > 9 )); then
  set_awning 100
  exit 0
fi
if (( ${CURRENT_HOUR} < 12 )); then
  set_awning 100
  exit 0
fi
if (( ${CURRENT_HOUR} > 19 )); then
  set_awning 100
  exit 0
fi

echo "its summer time, extend the awning to block out the heat ..."
# dont go lower than 33%, otherwise the awing collides with the raised garden beds
set_awning 33

