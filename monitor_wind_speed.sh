#!/bin/bash
set -euo pipefail

cd /root/home_automation/

SHELLY_AWNING_DEVICE_ID=a0a3b3b97a28
SHELLY_BALCONY_DEVICE_ID=10061ccbf524
SHELLY_OFFICE_DEVICE_ID=a0a3b3b96798
SHELLY_KITCHEN_DEVICE_ID=c82e180972f8
SHELLY_GALLERY_DEVICE_ID=cc7b5c0f7264
SHELLY_BEDROOM_DEVICE_ID=d48afc78764c
WIND_SPEED_SENSOR_URL="https://home-info.jamesclonk.io/sensor/28/values/1"

export CURRENT_WIND_SPEED=$(curl -s ${WIND_SPEED_SENSOR_URL} | jq -r '.[0].value' | awk '{print int($1);}')
echo "Current wind speed: ${CURRENT_WIND_SPEED} m/s"

if (( ${CURRENT_WIND_SPEED} > 3 )); then
  echo "have to protect awning ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_AWNING_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos' | awk '{print int($1);}')
  sleep 5
  if (( ${SHELLY_DATA} < 100 )); then # 100% for awning means fully retracted
    echo "fully retracting awning ..."
    curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_AWNING_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=100"
    sleep 5
  fi
fi

if (( ${CURRENT_WIND_SPEED} > 6 )); then
  echo "have to protect office blinds ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_OFFICE_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos' | awk '{print int($1);}')
  sleep 5
  if (( ${SHELLY_DATA} > 0 )); then # is it not fully closed?
    if (( ${SHELLY_DATA} < 4 )); then # if less than 4% open
      echo "fully closing office blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_OFFICE_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    elif (( ${SHELLY_DATA} < 100 )); then # if not fully open (100%)
      echo "fully opening office blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_OFFICE_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=100"
    fi
    sleep 5
  fi

  echo "have to protect kitchen blinds ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_KITCHEN_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos' | awk '{print int($1);}')
  sleep 5
  if (( ${SHELLY_DATA} > 0 )); then # is it not fully closed?
    if (( ${SHELLY_DATA} < 70 )); then # if somewhere between 1 and 69% open
      echo "fully closing kitchen blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_KITCHEN_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    elif (( ${SHELLY_DATA} < 100 )); then # if not fully open (100%)
      echo "fully opening kitchen blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_KITCHEN_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=100"
    fi
    sleep 5
  fi

  echo "have to protect gallery blinds ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_GALLERY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos' | awk '{print int($1);}')
  sleep 5
  if (( ${SHELLY_DATA} > 0 )); then # is it not fully closed?
    if (( ${SHELLY_DATA} < 70 )); then # if somewhere between 1 and 69% open
      echo "fully closing gallery blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_GALLERY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    elif (( ${SHELLY_DATA} < 100 )); then # if not fully open (100%)
      echo "fully opening gallery blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_GALLERY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=100"
    fi
    sleep 5
  fi

  echo "have to protect bedroom blinds ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_BEDROOM_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos' | awk '{print int($1);}')
  sleep 5
  if (( ${SHELLY_DATA} > 0 )); then # is it not fully closed?
    if (( ${SHELLY_DATA} < 50 )); then # if somewhere between 1 and 49% open
      echo "fully closing bedroom blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_BEDROOM_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    elif (( ${SHELLY_DATA} < 100 )); then # if not fully open (100%)
      echo "fully opening bedroom blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_BEDROOM_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=100"
    fi
    sleep 5
  fi
fi

if (( ${CURRENT_WIND_SPEED} > 9 )); then
  echo "have to protect balcony blinds ..."
  SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_BALCONY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}" | jq -r '.data.device_status."cover:0".current_pos' | awk '{print int($1);}')
  sleep 5
  if (( ${SHELLY_DATA} > 0 )); then # is it not fully closed?
    if (( ${SHELLY_DATA} < 4 )); then # if less than 4% open
      echo "fully closing balcony blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_BALCONY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=0"
    elif (( ${SHELLY_DATA} < 100 )); then # if not fully open (100%)
      echo "fully opening balcony blinds ..."
      curl -s ${SHELLY_CLOUD_URL}/device/relay/roller/control -d "id=${SHELLY_BALCONY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}&pos=100"
    fi
    sleep 5
  fi
fi
