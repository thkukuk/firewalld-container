# Firewalld Container Image

Firewall daemon (firewalld) container image with nftables as backend

## Run a firewalld instance

The firewalld container needs access to the host network and needs to run as privileged container.
The container image uses it's own dbus instance. This means, that other applications on the Host OS like NetworkManager, wicked, podman and similar cannot manage the firewall rules.

To start the container:

```
# podman run -d --rm --network host --privileged --name firewalld registry.opensuse.org/home/kukuk/container/firewalld:latest
```

## Persistent configuration files

By default changes to the default firewalld configuration are lost with a restart of the container, but the config files can be saved in a volume in `/etc/firewalld`:

```
# podman run -d --rm -v /etc/firewalld:/etc/firewalld --network host --privileged --name firewalld registry.opensuse.org/home/kukuk/container/firewalld:latest
```

### Environment variables:
```
  DEBUG=[0|1]    Enable debug mode.
  DBUS=[0|1]     Start own dbus daemon. If not a dbus socket needs to be provided.
```

## Manage firewalld instance

The firewalld instance should be managed with the CLI via `podman exec`
after the container has been started:

```
# podman exec firewalld firewall-cmd ...
```

## firewalld documentation

The manual page for `firewalld` can be read with:

```
# podman run -it --rm registry.opensuse.org/home/kukuk/container/firewalld:latest man firewalld
```

or for the `firewall-cmd` client:

```
# podman run -it --rm registry.opensuse.org/home/kukuk/container/firewalld:latest man firewall-cmd
```

## Building containers

There are two ways to build a firewalld container:

* [firewalld-image.kiwi](firewalld-image.kiwi) is a template for [kiwi](https://github.com/OSInside/kiwi) using the openSUSE busybox container as base container.
* [Dockerfile](Dockerfile) is a template to build the image the traditional way using the openSUSE Tumbleweed base container. The result is much bigger than with busybox.

## Reporting bugs

Please report bugs as [github issue](https://github.com/thkukuk/firewalld-container/issues)

