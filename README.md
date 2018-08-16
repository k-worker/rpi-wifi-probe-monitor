# rpi-wifi-probe-monitor

Unattended headless wifi probe monitoring on a raspberry pi.

This includes notes/scripts on getting my Raspberry Pi B+
set up, and other system configuration stuff I found helpful
for having the rpi listen on its own after boot.

Pull requests and issues welcome!

# Use Case

The idea is to research wifi probes in the wild using a raspberry
pi configured to headlessly capture wifi probes without user
input beyond connecting power. One example use case would be
connecting power to the device, gently placing it in a backpack,
and roaming around a town to capture probes.

# Setup

## Hardware

I have a Raspberry Pi model B+, a USB wifi interface with some kind of
Ralink chip that supports monitor mode on linux, and an external USB 
battery pack, 10,400mAh. The wifi interface is connected before boot,
currently the software doesn't support hotplugging it.

## Dependencies
First, make sure we have python installed, as well as virtualenv,
and pip

```
$ sudo apt install python python-pip python-virtualenv
```

Of course we'll also want the aircrack-ng suite for futzing around
manually, and for airmon-ng.

```
$ sudo apt install firmware-ralink aircrack-ng
```

We'll also want to make sure we have a wifi card we can put into
monitor mode, and any firmware it requires. My raspbian already
had firmware-ralink installed, so maybe that's raspbian default.
Either way if the interface isn't coming up or going into monitor
mode, make sure it's supported, and you have its specific firmware.

Note that if you want to run the probe monitor from within the venv,
you'll need to drop to a root terminal and source the activate script
to both be in the venv and have privileges to capture on the interface.

## Install This Software

I lazily hardcoded lots of things assuming that everything is installed in
`/home/pi/wifi-probe-monitoring/`. Maybe I'll fix this later. Until then,
either set up this path and install things there, or install where you like
and adjust the paths to match. Sorry!

git clone this repo to `/home/pi/wifi-probe-monitoring/`:

```
$ cd ~
$ mkdir ~/wifi-probe-monitoring
$ git clone ssh://<this repo.git> ~/wifi-probe-monitoring
```

Next, set up a virtualenv and install the python requirements:

```
$ cd ~/wifi-probe-monitoring
$ virtualenv venv
$ source venv/bin/activate
$ pip install -r requirements-sniff.txt
```

Now, notice that we have helper shell scripts for each step of the process.
The workflow is: 
1. Start monitor mode
2. Start capturing wifi probes
3. Stop monitor mode

Which are handled by the scripts `start_monitor_mode.sh`, `monitor_probes.sh`, and `stop_monitor_mode.sh`.
For convenience, the `do_everything.sh` script runs all these steps. To get the whole thing
running on startup in a default configuration, install the provided systemd unit file. When enabled,
it will be included in the services started on the default boot configuration:

```
$ sudo cp wifi-probe-monitor.service /home/systemd/system/
$ systemctl enable wifi-probe-monitor
```

If you don't want the service to run by default anymore, you can disable it:

```
$ systemctl disable wifi-probe-monitor
```

## Uninstall

Disable the systemd unit and make sure it's stopped (if currently running).

```
$ systemctl stop wifi-probe-monitor
$ systemctl disable wifi-probe-monitor
```

If you like, you can remove all the files as well.

```
$ sudo rm /etc/systemd/system/wifi-probe-monitor.service
$ rm -rf ~/wifi-probe-monitoring
```
