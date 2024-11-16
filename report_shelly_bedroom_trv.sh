#!/bin/bash

SHELLY_DEVICE_ID=34cdb078bc64
SENSOR_ID=32

while true; do
  export SHELLY_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}")
  export SHELLY_EPOCH=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:200".status.sys.unixtime')
  export SHELLY_VALVE_POS=$(echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:200".status."trv:0".pos')

  #echo ${SHELLY_DATA} | jq -r '.data.device_status."blutrv_rstatus:200"'
  echo "Epoch: ${SHELLY_EPOCH}"
  echo "Valve position: ${SHELLY_VALVE_POS}%"

  export EPOCH_CUTOFF=$(date --date "20 minutes ago" +'%s')
  echo "Epoch cutoff: ${EPOCH_CUTOFF}"
  if [[ ${SHELLY_EPOCH} > ${EPOCH_CUTOFF} ]]; then
    curl -X POST -d "value=${SHELLY_VALVE_POS}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_ID}/value"
  fi

  sleep 444
done

