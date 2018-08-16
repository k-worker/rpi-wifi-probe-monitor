#!/bin/bash
# run me as root!

# HARDCODED
source /home/pi/wifi-probe-monitoring/config.sh

if [[ $EUID -ne 0 ]]
then
	echo "run me as root!"
	exit 1
fi

# in our pi environment, start monitor mode on wlan0,
# since that's what my interface shows up as.
# However, try to be flexible and use whatever airmon-ng
# decides to name our interface (usually mon0)

regex='\(monitor mode enabled on (.+)\)'

# NOTE: if we have problems maintaining monitor mode, it may
# be wpa_supplicant or other tools fighting with us. We can
# use `airmon-ng kill` to stop these problematic processes.
# read the airmon-ng documentation on this.

output=$(airmon-ng start ${WIFI_INTERFACE})

if [[ $output =~ $regex ]]
then
	# successfully set up monitor mode
	interface="${BASH_REMATCH[1]}"
	echo $interface > ${APP_ROOT_DIR}/monitor_interface
else
	# uh, print error? nothing to reset.
	echo "failed to start monitoring on wlan0? Get an admin"
fi
