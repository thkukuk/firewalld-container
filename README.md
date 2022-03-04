# Firewalld Container Image

Firewall daemon (firewalld) container image

## Run a firewalld instance

The firewalld container needs access to the host's running system dbus, to the host network and needs to runas privileged container.

To start the container:
                          
```sh
  # podman run -d -v /run/dbus/system_bus_socket:/run/dbus/system_bus_socket \
               --network host --privileged \
               --name firewalld firewalld
```

## Manage firewalld instance

The firewalld instance should be managed with the CLI via `podman exec`
after the container has been started:

```sh
  # podman exec firewalld firewall-cmd ...
```

