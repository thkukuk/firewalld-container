#!/bin/sh
  
#======================================
# Functions...
#--------------------------------------
test -f /.profile && . /.profile

#======================================
# Greeting...
#--------------------------------------
echo "Configure image: [$kiwi_iname]..."

echo "Move /etc/firewalld away"
mkdir -p /usr/share/factory/etc/firewalld
mv /etc/firewalld/* /usr/share/factory/etc/firewalld/
