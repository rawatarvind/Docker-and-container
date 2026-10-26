# Build Contexts

> This article explains build contexts in Docker, their impact on build processes, and how to manage them effectively.

In this lesson, we'll explore what a **build context** is and how it influences the Docker build process. Understanding build contexts helps you optimize build times and reduce image size by sending only the necessary files to the Docker daemon.

## What Is a Build Context?

The *build context* is the set of files and folders the Docker CLI packages and sends to the Docker daemon when running `docker build`. By default, Docker uses the current directory (`.`) as the build context.

```bash theme={null}
docker build . -t my-custom-app
```

This command:

1. Archives everything under `.`.
2. Sends it to the Docker daemon.
3. Unpacks it into a temporary directory (e.g., `/var/lib/docker/tmp/...`).
4. Executes the instructions in your `Dockerfile`.

If you omit the `-t` (tag) flag, Docker builds the image and assigns the `latest` tag by default:

```bash theme={null}
docker build .
# results in an image tagged: IMAGE_ID:latest
```

## Example Dockerfile for a Flask App

```dockerfile theme={null}
FROM ubuntu

# Install Python and pip
RUN apt-get update && apt-get install -y python python-pip

# Install Flask and MySQL connector
RUN pip install flask flask-mysql

# Copy application source into the image
COPY . /opt/source-code

# Set environment variable and entrypoint
ENV FLASK_APP=/opt/source-code/app.py
ENTRYPOINT ["flask", "run"]
```

## Specifying a Different Build Context

You can point Docker to any local directory containing your `Dockerfile`:

```bash theme={null}
docker build /opt/my-custom-app -t my-custom-app
```

Docker will look for `/opt/my-custom-app/Dockerfile` and include all files under `/opt/my-custom-app` in the context.

## Common Context Sources

| Context Source | Command Example | Description |
| - | - | - |
| Current directory | `docker build . -t my-custom-app` | Sends `.` as the context |
| Local path | `docker build /opt/my-custom-app -t my-custom-app` | Uses a specified folder |
| Git repository | `docker build https://github.com/myaccount/myapp.git#feature-branch` | Clones a repo (or branch) as the build context |
| Custom Dockerfile | `docker build -f Dockerfile.dev https://github.com/myaccount/myapp.git` | Specifies an alternative `Dockerfile` location |

## Managing Context Size with `.dockerignore`

Sending large or unnecessary files (logs, build artifacts) can slow down builds, especially when the daemon is remote. To prevent this, create a `.dockerignore` file in your context root:

```text theme={null}
tmp
logs
build
```

Docker will exclude these paths when packaging the build context.

Be careful: missing important source files in `.dockerignore` can lead to build failures or incomplete images.

## Remote Docker Daemon Output

When using a remote Docker daemon, you’ll see output similar to:

```bash theme={null}
Sending build context to Docker daemon  2.048kB
Step 1/7 : FROM ubuntu
...
```

This confirms the context has been sent over the network before the build steps execute.

## Building from a Git Repository

Docker can directly use Git URLs as the build context:

```bash theme={null}
# Clone the default branch
docker build https://github.com/myaccount/myapp

# Build a specific branch
docker build https://github.com/myaccount/myapp#feature-branch

# Build only a subfolder within the repo
docker build https://github.com/myaccount/myapp.git#docker
```

By default, Docker looks for `Dockerfile` at the root of the checked‐out code. Use `-f` to point to a different file:

```bash theme={null}
docker build -f Dockerfile.dev https://github.com/myaccount/myapp
```

## Summary

* The **build context** defines what files are sent to the Docker daemon.
* Use `.dockerignore` to exclude unnecessary files and speed up builds.
* You can build from local paths or Git repositories.
* The `-f` flag lets you specify a non-default Dockerfile.

***

## Links and References

* [Docker Build Reference](https://docs.docker.com/engine/reference/commandline/build/)
* [Dockerignore Documentation](https://docs.docker.com/engine/reference/builder/#dockerignore-file)

