#!/bin/sh -eu

DEBUG=${DEBUG:-"0"}
FIREWALLD_ARGS=""

if [ "${DEBUG}" = "1" ]; then
    set -x
    FIREWALLD_ARGS="$FIREWALLD_ARGS --debug"
fi

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
    terminate /usr/bin/dbus-daemon
    terminate /usr/sbin/firewalld
}

start_daemons() {
    mkdir -p /run/dbus
    /usr/bin/dbus-daemon --system --fork
    exec catatonit -- /usr/sbin/firewalld --nofork $FIREWALLD_ARGS
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
