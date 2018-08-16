#!/bin/bash
#
# run me as root!
#
# string it all together. monitor + sniffing + teardown

# HARDCODED
source /home/pi/wifi-probe-monitoring/config.sh

if [[ $EUID -ne 0 ]]
then
	echo "run me as root!"
	exit 1
fi

echo "starting monitoring..."
${APP_ROOT_DIR}/start_monitor_mode.sh &&
	${APP_ROOT_DIR}/monitor_probes.sh

echo "shutting down..."
${APP_ROOT_DIR}/stop_monitor_mode.sh
