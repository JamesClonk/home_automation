#!/bin/bash

SHELLY_DEVICE_ID=34cdb078bc64
SENSOR_POS_ID_ONE=34
SENSOR_POS_ID_TWO=50
SENSOR_BAT_ID_ONE=46
SENSOR_BAT_ID_TWO=48

while true; do
  export SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}")
  #echo ${SHELLY_DATA} | jq -r '.data.device_status'

  echo "gallery main ..."
  export SHELLY_EPOCH=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:202".status.sys.unixtime')
  export SHELLY_VALVE_POS=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:202".status."trv:0".pos')
  export SHELLY_TARGET_TEMP=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:202".status."trv:0".target_C')
  export SHELLY_BATTERY_CHARGE=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv:202".battery')

  echo "Epoch: ${SHELLY_EPOCH}"
  echo "Valve position: ${SHELLY_VALVE_POS}%"
  echo "Target temperature: ${SHELLY_TARGET_TEMP}°C"
  echo "Battery charge: ${SHELLY_BATTERY_CHARGE}%"

  export EPOCH_CUTOFF=$(date --date "20 minutes ago" +'%s')
  echo "Epoch cutoff: ${EPOCH_CUTOFF}"
  if [[ ${SHELLY_EPOCH} > ${EPOCH_CUTOFF} ]]; then
    curl -X POST -d "value=${SHELLY_VALVE_POS}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_POS_ID_ONE}/value"
    curl -X POST -d "value=${SHELLY_BATTERY_CHARGE}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_BAT_ID_ONE}/value"
  fi

  sleep 7

  echo "gallery rig ..."
  export SHELLY_EPOCH=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:203".status.sys.unixtime')
  export SHELLY_VALVE_POS=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:203".status."trv:0".pos')
  export SHELLY_TARGET_TEMP=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:203".status."trv:0".target_C')
  export SHELLY_BATTERY_CHARGE=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv:203".battery')

  echo "Epoch: ${SHELLY_EPOCH}"
  echo "Valve position: ${SHELLY_VALVE_POS}%"
  echo "Target temperature: ${SHELLY_TARGET_TEMP}°C"
  echo "Battery charge: ${SHELLY_BATTERY_CHARGE}%"

  export EPOCH_CUTOFF=$(date --date "20 minutes ago" +'%s')
  echo "Epoch cutoff: ${EPOCH_CUTOFF}"
  if [[ ${SHELLY_EPOCH} > ${EPOCH_CUTOFF} ]]; then
    curl -X POST -d "value=${SHELLY_VALVE_POS}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_POS_ID_TWO}/value"
    curl -X POST -d "value=${SHELLY_BATTERY_CHARGE}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_BAT_ID_TWO}/value"
  fi

  sleep 777
done

