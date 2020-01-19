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
    curl -s -o /dev/null -w "%{http_code}" http://192.168.1.162/relay?state=0 | grep 200
}

retry 10 check
#curl http://192.168.1.162/relay?state=0

exit 0

