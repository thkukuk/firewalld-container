# Defines the tag for OBS and build script builds:
#!BuildTag: firewalld:latest
#!BuildTag: firewalld:%%MINOR%%
#!BuildTag: firewalld:%%PKG_VERSION%%
#!BuildTag: firewalld:%%PKG_VERSION%%-%RELEASE%

FROM opensuse/tumbleweed
LABEL maintainer="Thorsten Kukuk <kukuk@thkukuk.de>"

# Define labels according to https://en.opensuse.org/Building_derived_containers
# labelprefix=de.thkukuk.firewalld
LABEL org.opencontainers.image.title="A firewall daemon with D-Bus interface providing a dynamic firewall"
LABEL org.opencontainers.image.description="firewalld is a firewall service daemon that provides a dynamic customizable firewall with a D-Bus interface."
LABEL org.opencontainers.image.created="%BUILDTIME%"
LABEL org.opencontainers.image.version="%%PKG_VERSION%%-%RELEASE%"
LABEL org.opencontainers.image.url="https://github.com/thkukuk/firewalld-container"

COPY entrypoint.sh /entrypoint.sh

RUN zypper --non-interactive install --no-recommends kubernetes-pause mandoc firewalld && zypper clean && chmod 755 /entrypoint.sh
# Move /etc/firewalld away and save them if user does not provide any config
RUN mkdir -p /usr/share/factory/etc/firewalld && mv /etc/firewalld/* /usr/share/factory/etc/firewalld/

ENTRYPOINT ["/entrypoint.sh"]
CMD ["firewalld", "--nofork"]

