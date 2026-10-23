# Restart Policies

> Docker restart policies control automatic restarts of containers after failures or daemon restarts, ensuring reliability for services and jobs.

Docker restart policies let you control if and when a container is automatically restarted. Whether you’re running a critical web service or a batch job, these policies ensure your containers recover from failures or daemon restarts.

## Why Containers Stop

A container can exit for several reasons:

1. **Normal completion**\
   The primary process finishes successfully (exit code 0), for example, a script completes its task.
2. **Failure**\
   The process crashes or throws an error, exiting with a non-zero code (e.g., bad input).
3. **Manual intervention**\
   Running `docker container stop` sends a SIGTERM, then a SIGKILL after a timeout:
   * If the process traps SIGTERM and exits cleanly, it may return code 0.
   * If it’s killed with SIGKILL, it usually exits with a non-zero code.

When you need a container—say, a production API or CI runner—to restart immediately after a crash, Docker’s restart policies come into play.

## Docker Restart Policies

Specify a restart policy with `--restart` when you run a container:

| Policy | Behavior | CLI Flag |
| - | - | - |
| no (default) | Never restart automatically. | `--restart=no` |
| on-failure | Restart only if exit code ≠ 0. Optionally limit retries: `on-failure[:<max-retries>]`. | `--restart=on-failure:5` |
| always | Always restart regardless of exit status. If you manually stop the container, it will restart on daemon reboot. | `--restart=always` |
| unless-stopped | Like `always`, but honors manual stops across daemon restarts. | `--restart=unless-stopped` |

Use `on-failure[:<max-retries>]` to prevent infinite restart loops. Docker immediately retries with no backoff delay.

### Quick Reference

* **no**: No auto-restart.
* **on-failure**: Auto-restart only on errors (non-zero exit).
* **always**: Auto-restart on any exit.
* **unless-stopped**: Auto-restart on any exit, but not after a manual stop.

## Examples

### 1. Default (`no`)

```bash theme={null}
docker run --name test-no --restart=no ubuntu \
  expr 3 + 5
# Exits with 0; Docker does not restart.
```

### 2. On Failure

```bash theme={null}
docker run --name test-fail --restart=on-failure:3 ubuntu \
  expr three + 5
# Exits with 1; Docker retries up to 3 times, then stops.
```

### 3. Always

```bash theme={null}
docker run --name test-always --restart=always ubuntu \
  sleep 5
```

* After `sleep 5` finishes (exit 0), Docker restarts immediately.
* `docker stop test-always` prevents restart only until the next Docker daemon reboot.

### 4. Unless-Stopped

```bash theme={null}
docker run --name test-unless --restart=unless-stopped ubuntu \
  sleep 5
```

* Behaves like `always` on crashes or normal exit.
* Honors manual `docker stop` even if the daemon restarts later.

## Live Restore of Containers

By default, stopping the Docker daemon halts all containers. With **live restore**, containers remain running when the daemon is down.

1. Edit or create `/etc/docker/daemon.json`:
   ```json theme={null}
   {
     "live-restore": true
   }
   ```
2. Restart the Docker service:
   ```bash theme={null}
   sudo systemctl restart docker
   # or
   sudo systemctl reload docker
   ```

### Verifying Live Restore

Without live restore:

```bash theme={null}
docker run --name web httpd
sudo systemctl stop docker
# Containers stop when daemon stops.
sudo systemctl start docker
docker ps
# web is not running
```

With live restore enabled:

```bash theme={null}
docker run --name web httpd
sudo systemctl stop docker
# web stays running.
sudo systemctl start docker
docker ps
# web is still running
```

Live restore requires compatible Docker versions and proper permissions. Check the [Docker daemon.json reference][1] before enabling.

## Links and References

* [Docker Restart Policy Documentation][2]
* [Docker Daemon Configuration][1]
* [Docker Live Restore Deep Dive][3]

[1]: https://docs.docker.com/engine/reference/commandline/dockerd/#live-restore

[2]: https://docs.docker.com/config/containers/start-containers-automatically/

[3]: https://docs.docker.com/engine/admin/live-restore/

