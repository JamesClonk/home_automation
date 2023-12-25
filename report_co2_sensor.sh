#!/bin/bash

SENSOR_ID=22

while true; do
  export GOBLE_OUTPUT=$(goble EE:C8:36:2C:CB:39 2>/dev/null)
  export CO2_PPM=$(echo "${GOBLE_OUTPUT}" | grep 'CO2' | awk '{print $3;}')
  echo "CO2: ${CO2_PPM} ppm"

  if [[ "${CO2_PPM}" != "" ]]; then
    curl -X POST -d "value=${CO2_PPM}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_ID}/value"
  fi

  sleep 555
done

