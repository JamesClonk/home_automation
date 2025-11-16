#!/bin/bash

SENSOR_ID=52

while true; do
  export OCCUPANCY=$(curl -s "https://obloc.ch/_cmsbox_backends_/obloc/guestcounter/" | jq -r '.' | awk '{print int($1);}')
  echo "Current O'Bloc occupancy: ${OCCUPANCY}%"

  if [[ "${OCCUPANCY}" != "" ]]; then
    curl -X POST -d "value=${OCCUPANCY}" -u "${AUTH_USERNAME}:${AUTH_PASSWORD}" "https://home-info.jamesclonk.io/sensor/${SENSOR_ID}/value"
  fi

  sleep 777
done

