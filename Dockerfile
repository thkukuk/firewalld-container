# Defines the tag for OBS and build script builds:
#!BuildTag: firewalld:latest
#!BuildTag: firewalld:%%PKG_VERSION%%
#!BuildTag: firewalld:%%PKG_VERSION%%-%RELEASE%

FROM opensuse/tumbleweed
LABEL maintainer="Thorsten Kukuk <kukuk@thkukuk.de>"

LABEL INSTALL="/usr/bin/docker run --env container=oci --rm --privileged -v /:/host \${IMAGE} /container/label-install"
LABEL UPDATE="/usr/bin/docker run --rm --privileged -v /:/host \${IMAGE} /container/label-update"
LABEL UNINSTALL="/usr/bin/docker run --rm --privileged -v /:/host \${IMAGE} /container/label-uninstall"
LABEL RUN="/usr/bin/docker run -d --rm --name \${NAME} --privileged --net=host -v /etc/firewalld:/etc/firewalld -e DBUS=0 -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \${IMAGE} /usr/sbin/firewalld --nofork"
# Define labels according to https://en.opensuse.org/Building_derived_containers
# labelprefix=de.thkukuk.firewalld
LABEL org.opencontainers.image.title="A firewall daemon with D-Bus interface providing a dynamic firewall"
LABEL org.opencontainers.image.description="firewalld is a firewall service daemon that provides a dynamic customizable firewall with a D-Bus interface."
LABEL org.opencontainers.image.created="%BUILDTIME%"
LABEL org.opencontainers.image.version="%%PKG_VERSION%%-%RELEASE%"
LABEL org.opencontainers.image.url="https://github.com/thkukuk/firewalld-container"

COPY entrypoint.sh /entrypoint.sh
COPY container /container

RUN zypper --non-interactive install --no-recommends mandoc firewalld ebtables iptables ipset && zypper clean && chmod 755 /entrypoint.sh
# Move /etc/firewalld away and save them if user does not provide any config
RUN mkdir -p /usr/share/factory/etc/firewalld && mv /etc/firewalld/* /usr/share/factory/etc/firewalld/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["firewalld", "--nofork"]
