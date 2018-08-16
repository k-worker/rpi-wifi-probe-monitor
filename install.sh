#!/bin/bash
#
# run me as root!
#
# install the systemd unit. If you want it uninstalled, read the docs and undo these operations
# (disable the systemd unit and remove the unit file from /etc/systemd/system)

# HARDCODED
source /home/pi/wifi-probe-monitoring/config.sh

if [[ $EUID -ne 0 ]]
then
	echo "run me as root!"
	exit 1
fi

cp ${APP_ROOT_DIR}/wifi-probe-monitor.service /etc/systemd/system/
systemctl daemon-reload
systemctl enable wifi-probe-monitor
