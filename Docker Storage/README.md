# Docker Storage

> Explains Docker storage fundamentals, covering storage drivers and volume plugins, their performance and persistence roles, and how they relate to Kubernetes storage concepts.

Understanding how storage works with containers is the first step to mastering storage in Kubernetes. Docker storage has two primary concepts that determine how container filesystems and external storage are handled:

* Storage drivers — how Docker manages the writable container filesystem and image layers (e.g., overlay2, aufs, devicemapper).
* Volume driver plugins — how Docker connects external storage backends (volumes) to containers, enabling persistent data across container lifecycles.

To get the most out of Kubernetes storage later, ensure you’re familiar with these Docker fundamentals.

| Concept | Purpose | When to use |
| - | - | - |
| Storage drivers | Manage container image layers and the container’s writable filesystem | Required for local container runtime behavior and performance tuning |
| Volume driver plugins | Integrate external or networked storage with containers (persistent volumes) | When you need data to persist beyond a container lifecycle or to share data between containers |

In this lesson we’ll focus on storage drivers. If you’ve already covered this in the [Docker Training Course for the Absolute Beginner](https://learn.kodekloud.com/user/courses/docker-training-course-for-the-absolute-beginner), you may use this as a concise refresher.

![A presentation slide titled "DOCKER STORAGE" with two columns separated by a thin vertical line, labeled "STORAGE DRIVERS" on the left and "VOLUME DRIVERS" on the right. The design is minimal with large bold text on a white background.](https://mintcdn.com/kodekloud-c4ac6d9a/iav9qAXZcODraaeZ/images/Docker-Certified-Associate-Exam-Course/Docker-Engine-Storage/Docker-Storage/docker-storage-drivers-volume-drivers-slide.jpg?fit=max\&auto=format\&n=iav9qAXZcODraaeZ\&q=85\&s=92c485877aacbfe1d2563755da4ae5eb)

If you already understand Docker storage drivers and volume driver plugins, you can skip this lesson. Otherwise, continuing here will give you the Docker fundamentals needed to understand Kubernetes storage concepts.

What you’ll learn in this section:

* How storage drivers affect container layer management and performance.
* Differences between common storage drivers (e.g., overlay2 vs devicemapper).
* When to choose a specific storage driver for development or production.
* How volume driver plugins relate to persistent storage and how that maps to Kubernetes concepts.

Further reading and references:

* [Docker Storage Drivers Overview (official docs)](https://docs.docker.com/storage/storagedriver/)
* [Kubernetes Storage Concepts](https://kubernetes.io/docs/concepts/storage/)

