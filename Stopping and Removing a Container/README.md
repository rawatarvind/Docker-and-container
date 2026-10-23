# Stopping and Removing a Container

> This guide covers managing Docker containers, including stopping, pausing, resuming, and removing them, along with Linux signal mappings and cleanup best practices.

In this guide, we’ll explore how to manage Docker containers by stopping, pausing, resuming, and removing them. You’ll also learn how Linux signals map to Docker commands, plus best practices for cleaning up containers to reclaim resources.

***

## 1. Linux Signals Refresher

Linux processes respond to signals for control and shutdown. Below is a quick overview:

| Signal | Action | Description |
| - | - | - |
| SIGSTOP | Pause | Suspends the process, cannot be caught. |
| SIGCONT | Resume | Continues a paused process. |
| SIGTERM | Graceful shutdown | Allows process cleanup before exit. |
| SIGKILL | Forceful kill | Immediately terminates; cannot be trapped. |

```bash theme={null}
# Pause Apache httpd
kill -SIGSTOP 11663

# Resume it
kill -SIGCONT $(pgrep httpd)

# Graceful shutdown
kill -SIGTERM $(pgrep httpd)

# Forceful kill
kill -SIGKILL $(pgrep httpd)
# shorthand
kill -9 $(pgrep httpd)
```

`SIGTERM` is the preferred way to stop a process because it allows cleanup. `SIGKILL` should be used only if the process does not terminate gracefully.

***

## 2. Docker Container Equivalents

Docker uses similar primitives at the container level. The table below shows the mappings:

| Action | Linux Signal | Docker Command |
| - | - | - |
| Pause | SIGSTOP/SIGCONT | `docker pause` / `docker unpause` |
| Stop | SIGTERM → SIGKILL | `docker stop` |
| Kill | SIGKILL | `docker kill --signal=SIGKILL` |
| Remove | — | `docker rm` |

### 2.1 Running an HTTPD Container

```bash theme={null}
docker run --name web httpd
```

### 2.2 Pause and Resume

```bash theme={null}
docker pause web
docker unpause web
```

### 2.3 Stop (SIGTERM then SIGKILL)

```bash theme={null}
docker stop web
```

Docker sends `SIGTERM`, waits the default 10 seconds, then sends `SIGKILL` if the container is still running.

***

## 3. Sending Custom Signals

You can target any signal to a container’s main process:

```bash theme={null}
# Send SIGKILL by name
docker kill --signal=SIGKILL web

# Or by number
docker kill --signal=9 web
```

***

## 4. Removing a Container

Containers must be stopped before removal:

```bash theme={null}
docker stop web
docker rm web
```

Attempting to remove a running container yields an error:

```bash theme={null}
$ docker rm web
Error response from daemon:
You cannot remove a running container ... Stop the container before attempting removal or use --force
```

***

## 5. Batch Stopping and Removing

When managing multiple containers, leverage `docker ps -q` and `docker ps -aq`:

```bash theme={null}
# Stop all running containers
docker stop $(docker ps -q)

# Remove all containers (running & exited)
docker rm $(docker ps -aq)
```

***

## 6. Pruning Stopped Containers

To delete **all stopped** containers and free disk space:

```bash theme={null}
docker container prune
```

`docker container prune` permanently deletes **all** stopped containers. There is no undoing this action.

***

## 7. Automatic Cleanup with --rm

For ephemeral containers, use `--rm` to remove them automatically after exit:

```bash theme={null}
docker run --rm ubuntu expr 4 + 5
# Output: 9
```

This is ideal for one-off tasks, CI jobs, or simple shell commands.

***

## Links and References

* [Docker CLI Commands](https://docs.docker.com/engine/reference/commandline/cli/)
* [Docker Pause Documentation](https://docs.docker.com/engine/reference/commandline/pause/)
* [Linux Signals](https://man7.org/linux/man-pages/man7/signal.7.html)
