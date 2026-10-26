# Demo Logging Driver

> This tutorial covers managing Dockers logging drivers, including checking defaults, changing settings, and applying options for individual containers.

In this tutorial, you’ll learn how to manage Docker’s logging drivers—check the default, switch the daemon-wide setting, apply advanced options, and override the driver for individual containers.

## 1. Check the Default Logging Driver

Docker uses the `json-file` driver by default, storing container logs as JSON on the host.

```bash theme={null}
# Verify the current logging driver
docker system info | grep -i "logging driver"
# Output: Logging Driver: json-file
```

The `json-file` driver is the standard Docker logging backend. It’s easy to parse and works out of the box.

## 2. Create and Inspect a Test Container

Run an Ubuntu container to see its inherited log configuration:

```bash theme={null}
# Start a detached Ubuntu container
docker container run -itd --name test-container ubuntu
```

Inspect its log settings:

```bash theme={null}
docker container inspect test-container \
  --format='{{json .HostConfig.LogConfig}}'
# Output:
# {
#   "Type": "json-file",
#   "Config": {}
# }
```

## 3. Supported Logging Drivers

Docker supports multiple logging backends for different use cases. You can find the full list in the official docs:\
[Configure containers → Logging](https://docs.docker.com/config/containers/logging/configure/)

![The image shows a section of the Docker documentation webpage, specifically listing and describing various logging drivers available for Docker containers.](https://kodekloud.com/kk-media/image/upload/v1752873905/notes-assets/images/Docker-Certified-Associate-Exam-Course-Demo-Logging-Driver/docker-logging-drivers-documentation.jpg)

| Driver | Use Case |
| - | - |
| json-file | Local JSON logs, simple parsing |
| syslog | Centralized logging to syslog daemon |
| journald | Integration with systemd’s journal |
| fluentd | Forward logs to a Fluentd collector |
| awslogs | Ship logs to Amazon CloudWatch Logs |
| splunk | Send logs to a Splunk HTTP Event Collector (HEC) |
| … | And others (gcplogs, logentries, etc.) |

## 4. Change the Default Driver to Syslog

To switch the daemon-wide driver to `syslog`, edit `/etc/docker/daemon.json`:

Modifying `daemon.json` requires restarting the Docker daemon. Existing containers will continue using their current driver until recreated.

1. Stop Docker:
   ```bash theme={null}
   sudo systemctl stop docker
   ```
2. Update `/etc/docker/daemon.json`:
   ```json theme={null}
   {
     "log-driver": "syslog"
   }
   ```
3. Restart Docker:
   ```bash theme={null}
   sudo systemctl start docker
   ```
4. Verify:
   ```bash theme={null}
   docker system info | grep -i "logging driver"
   # Output: Logging Driver: syslog
   ```

## 5. Advanced Logging Options

You can fine-tune log behavior with `log-opts`. For example, to limit file size and rotation on `json-file`:

```json theme={null}
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  },
  "labels": "production_status",
  "env": "os_customer"
}
```

Retrieve the current default driver in scripts:

```bash theme={null}
docker info --format '{{.LoggingDriver}}'
# e.g., json-file
```

## 6. Override the Logging Driver per Container

Even when the daemon default is `syslog`, you can pick a different driver for a specific container:

```bash theme={null}
docker container run -itd \
  --name logtest \
  --log-driver journald \
  ubuntu
```

Confirm the override:

```bash theme={null}
docker container inspect logtest \
  --format='{{json .HostConfig.LogConfig}}'
# Output:
# {
#   "Type": "journald",
#   "Config": {}
# }
```

## 7. Conclusion

You’ve learned how to:

* Check and view Docker’s default logging driver
* Change the daemon-wide driver in `/etc/docker/daemon.json`
* Apply advanced options like rotation and size limits
* Override logging drivers for individual containers

Happy logging!

***

## References

* [Docker Logging Drivers Documentation](https://docs.docker.com/config/containers/logging/configure/)
* [Docker System Info](https://docs.docker.com/engine/reference/commandline/system_info/)
* [Docker Container Inspect](https://docs.docker.com/engine/reference/commandline/inspect/)

