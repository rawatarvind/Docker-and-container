# Copying Contents into Container

> This guide explains how to transfer files and directories between a Docker host and a running container using the docker container cp command.

In this guide, you’ll learn how to transfer files and directories between your Docker host and a running container using the `docker container cp` command. This utility works in both directions:

* Host → Container
* Container → Host

Assume you have:

* A container named `webapp` running on your Docker host
* A file on the host at `/tmp/web.conf`

***

## Copying from Host to Container

### Syntax

```bash theme={null}
docker container cp [HOST_PATH] [CONTAINER_NAME]:[CONTAINER_PATH]
```

### Example

```bash theme={null}
docker container cp /tmp/web.conf webapp:/etc/web.conf
```

* **Source (host):** `/tmp/web.conf`
* **Destination (container):** `webapp:/etc/web.conf`

If you specify a directory as the destination, ensure that directory already exists inside the container.

***

## Copying from Container to Host

Simply reverse the source and destination:

```bash theme={null}
docker container cp webapp:/etc/web.conf /tmp/web.conf
```

* **Source (container):** `webapp:/etc/web.conf`
* **Destination (host):** `/tmp/web.conf`

Any existing file at the destination path will be overwritten without confirmation.

***

## Copying Entire Directories

To copy a complete directory (including its contents), include trailing slashes:

```bash theme={null}
docker container cp ./config/ webapp:/etc/config
```

This command transfers your local `config` folder into `/etc/config` inside the `webapp` container. Ensure `/etc/config` exists in the container before running the command.

***

## Command Reference

| Direction | Command Syntax | Description |
| - | - | - |
| Host → Container | `docker container cp /path/on/host container_name:/path/in/container` | Copy files or directories into container |
| Container → Host | `docker container cp container_name:/path/in/container /path/on/host` | Copy files or directories to host |

***

## Links and References

* [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/)
* [docker container cp Documentation](https://docs.docker.com/engine/reference/commandline/cp/)

