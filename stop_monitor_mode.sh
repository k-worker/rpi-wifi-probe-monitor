#!/bin/bash
# run me as root!
#
# Considering the 'typical' use case is we stop when we lose power, this seems useless,
# but may be useful in dev testing and future setups

# HARDCODED
source /home/pi/wifi-probe-monitoring/config.sh

if [[ $EUID -ne 0 ]]
then
	echo "run me as root!"
	exit 1
fi

if [[ -f ${APP_ROOT_DIR}/monitor_interface ]]
then
	airmon-ng stop $(cat ${APP_ROOT_DIR}/monitor_interface) &>/dev/null && rm ${APP_ROOT_DIR}/monitor_interface
fi
