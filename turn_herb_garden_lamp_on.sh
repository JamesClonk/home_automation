#!/bin/bash

retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1

    until $cmd
    do
        if (( attempt_num == max_attempts ))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            echo "Attempt $attempt_num failed! Trying again in $attempt_num seconds..."
            sleep $(( attempt_num++ ))
        fi
    done
}

check() {
    echo "checking lamp state ..."
    RELAY_STATE=$(curl -s http://192.168.1.164/report | jq .relay)
    if [[ "${RELAY_STATE}" != "true" ]]; then
        echo "lamp is currently off, turning it on ..."
        curl -s -o /dev/null -w "%{http_code}" http://192.168.1.164/relay?state=1 | grep 200
    fi
}

retry 10 check
#curl http://192.168.1.164/relay?state=1

exit 0

