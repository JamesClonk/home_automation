#!/bin/bash

SHELLY_DEVICE_ID=34b7da8cd9a4
SENSOR_ID_TEMP=25
SENSOR_ID_HUM=26

while true; do
  export SHELLY_HT_DATA=$(curl -s ${SHELLY_CLOUD_URL}/device/status -d "id=${SHELLY_DEVICE_ID}&auth_key=${SHELLY_AUTH_KEY}")
  export SHELLY_EPOCH=$(echo ${SHELLY_HT_DATA} | jq -r '.data.device_status.sys.unixtime')
  export SHELLY_TEMP=$(echo ${SHELLY_HT_DATA} | jq -r '.data.device_status."temperature:0".tC')
  export SHELLY_HUM=$(echo ${SHELLY_HT_DATA} | jq -r '.data.device_status."humidity:0".rh')

  export TEMP_SHORT=$(echo "${SHELLY_TEMP}" | awk '{print int($1);}')
  export HUM_SHORT=$(echo "${SHELLY_HUM}" | awk '{print int($1);}')

  echo "Epoch: ${SHELLY_EPOCH}"
  echo "Temperature: ${SHELLY_TEMP}C (${TEMP_SHORT}°)"
  echo "Humidity: ${SHELLY_HUM}RH (${HUM_SHORT}%)"

  export EPOCH_CUTOFF=$(date --date "15 minutes ago" +'%s')
  if [[ ${SHELLY_EPOCH} > ${EPOCH_CUTOFF} ]] && [[ "${TEMP_SHORT}" != "0" ]]; then
    curl -X POST -d "value=${TEMP_SHORT}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_ID_TEMP}/value"
    curl -X POST -d "value=${HUM_SHORT}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_ID_HUM}/value"
  fi

  sleep 444
done

