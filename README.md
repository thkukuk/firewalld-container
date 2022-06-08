# Firewalld Container Image

Firewall daemon (firewalld) container image with nftables as backend

## Run a firewalld instance

The firewalld container needs access to the host network and needs to run as
privileged container.
This container image uses the system dbus instance. This means, that you
need to install at first the dbus and polkit configuration files.
Optional you can use the dbus daemon provided by the container image. But this
means that other applications on the Host OS like NetworkManager, wicked,
podman and similar cannot manage the firewall rules.

The container image provides three runlabels:

* INSTALL: installs the dbus and polkit files, a firewall-cmd wrapper and a systemd service
* UNINSTALL: removes the by `INSTALL` created files except for configuration files
* RUN: starts the container. /etc/firewalld and the dbus socket will be mounted into the container


### Initialize the system

```
# podman container runlabel install registry.opensuse.org/home/kukuk/container/firewalld
```

Will prepare the system. The following files will be created on the host OS:
* /etc/dbus-1/system.d/FirewallD.conf
* /etc/polkit-1/actions/org.fedoraproject.FirewallD1.policy
* /etc/systemd/system/firewalld.service
* /etc/default/container-firewalld
* /usr/local/bin/firewall-cmd

The polkit policy will only be installed if polkit itself is installed. It may
be necessary to restart the dbus and polkit daemon afterwards.

`/usr/local/bin/firewall-cmd` is a wrapper to call firewall-cmd inside the
container. docker and podman are supported.

The systemd service and the corresponding config file
`/etc/default/container-firewalld` allow to start/stop the container with
systemd if podman is used as container runtime.

### Running the container

#### runlabel

To run the firewall container with the label `RUN`:

```
# podman container runlabel run registry.opensuse.org/home/kukuk/container/firewalld
```

This command will run the container as privileged container with host
network. Additional /etc/firewalld and the dbus socket are mounted into the container.

#### systemd/podman

Adjust `/etc/default/container-firewalld` to your needs.

To start the container: `systemctl start firewalld`
To stop the container: `systemctl stop firewalld`

#### manual

```
# podman run -d --rm --network host --privileged -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket -v /etc/firewalld:/etc/firewalld --name firewalld registry.opensuse.org/home/kukuk/container/firewalld:latest
```

### De-install the files

```
# podman container runlabel uninstall registry.opensuse.org/home/kukuk/container/firewalld
```

Will remove all generated files except the configuration files.

### Environment variables:
```
  DEBUG=[0|1]    Enable debug mode. By default off.
  DBUS=[0|1]     Start own dbus daemon. If not a dbus socket needs to be provided. By default disabled.
```

## Manage firewalld instance

The firewalld instance should be managed with the CLI via `podman exec`
after the container has been started:

```
# podman exec firewalld firewall-cmd ...
```

Or with the `/usr/local/bin/firewall-cmd` wrapper.

## firewalld documentation

The manual page for `firewalld` can be read with:

```
# podman run -it --rm registry.opensuse.org/home/kukuk/container/firewalld man firewalld
```

or for the `firewall-cmd` client:

```
# podman run -it --rm registry.opensuse.org/home/kukuk/container/firewalld man firewall-cmd
```

## Building containers

There are two ways to build a firewalld container:

* [firewalld-image.kiwi](firewalld-image.kiwi) is a template for [kiwi](https://github.com/OSInside/kiwi) using the openSUSE busybox container as base container.
* [Dockerfile](Dockerfile) is a template to build the image the traditional way using the openSUSE Tumbleweed base container. The result is much bigger than with busybox and the Dockerfile does not really work yet.

## Reporting bugs

Please report bugs as [github issue](https://github.com/thkukuk/firewalld-container/issues)
