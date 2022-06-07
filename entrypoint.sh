#!/bin/bash -eu

DEBUG=${DEBUG:-"0"}
DBUS=${DBUS:-"0"}
FIREWALLD_ARGS=""

if [ "${DEBUG}" = "1" ]; then
    set -x
    FIREWALLD_ARGS="$FIREWALLD_ARGS --debug"
fi

export PATH=/usr/sbin:/sbin:${PATH}

start_dbus() {
    if [ "${DBUS}" = "1" ]; then
        mkdir -p /run/dbus
        /usr/bin/dbus-daemon --system --fork
    fi
}

#
# Main
#

# shortcut for podman runlabel calls
if [ $(basename "$1") = 'label-install' ] ||
       [ $(basename "$1") = 'label-uninstall' ]; then
    exec "$@"
fi

# if command starts with an option, prepend firewalld
if [ "${1:0:1}" = '-' ]; then
     set -- firewalld --nofork "$@"
fi

# If no firewalld config is provided, use default one
if [ ! "$(ls -A /etc/firewalld)" ]; then
    cp -av /usr/share/factory/etc/firewalld/* /etc/firewalld/
fi

if [ $(basename "$1") = 'firewalld' ]; then
    start_dbus
    # shellcheck disable=SC2086
    set -- "$@" $FIREWALLD_ARGS
fi

exec "$@"
