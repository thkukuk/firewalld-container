#!/bin/sh

DEBUG=${DEBUG:-"0"}

[ "${DEBUG}" = "1" ] && set -x

export PATH=/usr/sbin:/sbin:${PATH}

terminate() {
    base=$(basename "$1")
    pid=$(/bin/pidof "$base")

    if [ -n "$pid" ]; then
	echo "Terminating $base..."
	if kill "$pid" ; then
	    echo "Terminating $base failed!"
	fi
    else
	echo "Failure determining PID of $base"
    fi
}

init_trap() {
    trap stop_daemons TERM INT
}

stop_daemons() {
    terminate /usr/bin/dbus-broker
    terminate /usr/sbin/firewalld
}

start_daemons() {
    mkdir /run/dbus
    dbus-daemon --system --fork
    "$@"
}

#
# Main
#

init_trap

if [ "$1" = 'firewalld' ]; then
    start_daemons "$@"
    echo "firewalld running and ready"
    /usr/bin/pause
else
    exec "$@"
fi
