# Docker commit method

> Learn to create a Docker image from a running container using docker container commit for rapid prototyping or debugging changes.

In this guide, you’ll learn how to create a Docker image from a running container using `docker container commit`. This technique can be useful for rapid prototyping or debugging changes without writing a Dockerfile. For production-grade images, you should still prefer the Dockerfile approach to ensure repeatability and version control.

## Overview

Typically, custom images are built with a Dockerfile:

```bash theme={null}
docker build -t myapp:latest .
```

Alternatively, you can:

1. Launch a container from a base image (e.g., `httpd`).
2. Modify files or install packages inside the container.
3. Commit the container’s state as a new image.

The `docker commit` workflow is not recommended for production systems. Use a Dockerfile for maintainability, readability, and versioning.

## When to Use `docker commit`

| Scenario | Recommended? | Alternative |
| - | - | - |
| One-off experiments | Yes | Dockerfile (optional) |
| Capturing state for debugging | Yes | Volumes, logging |
| Production-ready, repeatable CI | No | Dockerfile |

## Step-by-Step Example

1. **Run an `httpd` container in detached mode**
   ```bash theme={null}
   docker run -d --name httpd httpd
   ```

2. **Enter the container and update the default web page**
   ```bash theme={null}
   docker exec -it httpd bash
   root@container:/# cat > /usr/local/apache2/htdocs/index.html <<EOF
   Welcome to my custom web application
   EOF
   root@container:/# exit
   ```

3. **Commit the container state to a new image**
   ```bash theme={null}
   docker container commit -a "Ravi" httpd customhttpd
   ```

4. **Verify the new image**
   ```bash theme={null}
   docker image ls
   REPOSITORY    TAG       IMAGE ID       CREATED         SIZE
   customhttpd   latest    adac0f56a7df   5 seconds ago   138MB
   httpd         latest    417af7dc28bc   8 days ago      138MB
   ```

## Comparison: Dockerfile vs. `docker commit`

| Feature | Dockerfile | `docker commit` |
| - | - | - |
| Version control | Yes (plain text) | No |
| Automation | CI/CD pipelines | Manual or scripted |
| Reproducibility | High | Low |
| Ease of simple tweaks | Moderate | Very fast |
| Best practice for production | ✔ | ✖ |

## References

* [Dockerfile reference](https://docs.docker.com/engine/reference/builder/)
* [docker container commit](https://docs.docker.com/engine/reference/commandline/container_commit/)
* [docker exec documentation](https://docs.docker.com/engine/reference/commandline/exec/)
* [Docker image management](https://docs.docker.com/engine/reference/commandline/image_ls/)

