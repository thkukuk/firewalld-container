# Firewalld Container Image

Firewall daemon (firewalld) container image

## Run a firewalld instance

The firewalld container needs access to the host's running system dbus, to the host network and needs to runas privileged container.

To start the container:
                          
```
podman run -d -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket --network host --privileged --name firewalld firewalld
```

## Persistent configuration files

By default changes to the default firewalld configuration are lost with a restart of the container, but the config files can be saved in a volume in `/etc/firewalld`:

```
podman run -d -v /etc/firewalld:/etc/firewalld -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket --network host --privileged --name firewalld firewalld
```

## Manage firewalld instance

The firewalld instance should be managed with the CLI via `podman exec`
after the container has been started:

```
podman exec firewalld firewall-cmd ...
```

