#!/bin/bash

TEMP_SENSOR_ID=1
HUM_SENSOR_ID=2
CO2_SENSOR_ID=22

while true; do
  export GOBLE_OUTPUT=$(goble EE:C8:36:2C:CB:39 2>/dev/null)
  export TEMP=$(echo "${GOBLE_OUTPUT}" | grep 'Temperature' | awk '{print int($2)-1;}')
  export HUM=$(echo "${GOBLE_OUTPUT}" | grep 'Humidity' | awk '{print int($2)+5;}')
  export CO2_PPM=$(echo "${GOBLE_OUTPUT}" | grep 'CO2' | awk '{print $3;}')
  echo "Temperature: ${TEMP}°C"
  echo "Humidity: ${HUM}% RH"
  echo "CO2: ${CO2_PPM} ppm"

  if [[ "${TEMP}" != "" ]]; then
    curl -X POST -d "value=${TEMP}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${TEMP_SENSOR_ID}/value"
  fi
  if [[ "${HUM}" != "" ]]; then
    curl -X POST -d "value=${HUM}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${HUM_SENSOR_ID}/value"
  fi
  if [[ "${CO2_PPM}" != "" ]]; then
    curl -X POST -d "value=${CO2_PPM}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${CO2_SENSOR_ID}/value"
  fi

  sleep 555
done

