#!/bin/bash

echo "starting python sleep"
python -c 'import time; time.sleep(100)' &
TARGET_PID=$!

echo "child python pid: ${TARGET_PID}"

trap 'kill ${TARGET_PID}' INT
trap 'kill ${TARGET_PID}' KILL #doesn't work!

while $(sleep 1s)
do
	echo "slept"
done
