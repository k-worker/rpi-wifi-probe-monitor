#!/bin/bash
# run me as root!
# TODO: make log/probemon.py paths better/nicer?

# HARDCODED
source /home/pi/wifi-probe-monitoring/config.sh

if [[ $EUID -ne 0 ]]
then
	echo "run me as root!"
	exit 1
fi

# source the venv. If you aren't doing this, comment me out
source ${APP_ROOT_DIR}/venv/bin/activate

# get the monitor interface from file
if [[ ! -f ${APP_ROOT_DIR}/monitor_interface ]]
then
	echo "no monitor interface file ${APP_ROOT_DIR}/monitor_interface"
	echo "start monitor mode first"
	exit 1
fi

MONITOR_INTERFACE=$(cat ${APP_ROOT_DIR}/monitor_interface)

mkdir -p ${APP_ROOT_DIR}/logs

log_filename=$(date +%F_%T.log)
echo "logging probes to: ${LOG_DIR}/${log_filename}"
python ${APP_ROOT_DIR}/probemon.py -f -s -r -i ${MONITOR_INTERFACE} -o ${LOG_DIR}/${log_filename} &

# kill our background job if we get killed
PROBE_LOGGER_PID=$!
trap 'kill ${PROBE_LOGGER_PID}' SIGTERM SIGINT

# check if our python script exited early
sleep 1s

if ! ps -p ${PROBE_LOGGER_PID} &>/dev/null
then
	# monitor failed to start, exit
	echo "probemon.py failed to start"
	exit 1
fi

# loop forever, flushing filesystem buffers to disk once a minute
# NOTE: we may still get fs corruption when we eventually lose power,
# but hopefully this makes that less likely, or minimizes data lost.
while $(sleep 1m)
do
	sync
done
