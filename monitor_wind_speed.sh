#!/bin/bash
set -euo pipefail

cd /root/home_automation/

SHELLY_AWNING_DEVICE_ID=a0a3b3b97a28
SHELLY_BALCONY_DEVICE_ID=10061ccbf524
SHELLY_OFFICE_DEVICE_ID=a0a3b3b96798
SHELLY_KITCHEN_DEVICE_ID=c82e180972f8
SHELLY_GALLERY_DEVICE_ID=cc7b5c0f7264
WIND_SPEED_SENSOR_URL="https://home-info.jamesclonk.io/sensor/28/values/1"

export CURRENT_WIND_SPEED=$(curl -s ${WIND_SPEED_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
echo "Current wind speed: ${CURRENT_WIND_SPEED} m/s"

if (( ${CURRENT_WIND_SPEED} > 3 )); then
  echo "have to close awning ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_AWNING_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos')
  sleep 5
  if [[ "${SHELLY_DATA}" != "100" ]]; then
    curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_AWNING_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=100"
    sleep 5
  fi
fi

if (( ${CURRENT_WIND_SPEED} > 6 )); then
  echo "have to close outside blinds ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_OFFICE_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos')
  sleep 5
  if [[ "${SHELLY_DATA}" != "0" ]]; then
    curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_OFFICE_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    sleep 5
  fi

  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_KITCHEN_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos')
  sleep 5
  if [[ "${SHELLY_DATA}" != "0" ]]; then
    curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_KITCHEN_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    sleep 5
  fi

  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_GALLERY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos')
  sleep 5
  if [[ "${SHELLY_DATA}" != "0" ]]; then
    curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_GALLERY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    sleep 5
  fi
fi

if (( ${CURRENT_WIND_SPEED} > 9 )); then
  echo "have to close balcony blinds ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_BALCONY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos')
  sleep 5
  if [[ "${SHELLY_DATA}" != "0" ]]; then
    curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_BALCONY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    sleep 5
  fi
fi

