#!/bin/sh -eux

DEBUG=${DEBUG:-"0"}

[ "${DEBUG}" = "1" ] && set -x

export PATH=/usr/sbin:/sbin:${PATH}

echo "Arguments $@"

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
    mkdir -p /run/dbus
    /usr/bin/dbus-daemon --system --fork
    /usr/sbin/firewalld --nofork
}

#
# Main
#

init_trap

if [ "$1" = 'firewalld' ]; then
    start_daemons "$@"
else
    exec "$@"
fi
