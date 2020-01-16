#!/bin/bash

SENSOR_ID=8

while true; do
  export LAMP_TEMP_LONG=$(curl http://192.168.1.160/temp -s | jq -r '.compensated')
  export LAMP_TEMP_SHORT=$(printf "%0.1f" ${LAMP_TEMP_LONG})
  export LAMP_TEMP=$(echo "${LAMP_TEMP_LONG}" | awk '{print int($1);}')
  echo "Temp: ${LAMP_TEMP_SHORT}C (${LAMP_TEMP}°)"

  curl -X POST -d "value=${LAMP_TEMP}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.scapp.io/sensor/${SENSOR_ID}/value"

  sleep 300
done

