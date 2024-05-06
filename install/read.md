# Install Docker Engine on CentOS

Prerequisites
OS requirements
To install Docker Engine, you need a maintained version of one of the following CentOS versions:

CentOS 7
CentOS 8 (stream)
CentOS 9 (stream)

# Uninstall old versions


sudo yum remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine
yum might report that you have none of these packages installed.

Images, containers, volumes, and networks stored in /var/lib/docker/ aren't automatically removed when you uninstall Docker.

# Installation methods

you can install Docker Engine in different ways, depending on your needs:

using repo or install the rpm package.

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

Install Docker Engine
Install latest version in Cent OS.
Install Docker Engine, containerd, and Docker Compose

sudo yum install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

If prompted to accept the GPG key, verify that the fingerprint matches 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35, and if so, accept it.

This command installs Docker, but it doesn't start Docker. It also creates a docker group, however, it doesn't add any users to the group by default.

sudo systemctl start docker
sudo systemctl enalbe docker
sudo systemctl status docker

# Uninstall Docker Engine

Uninstall the Docker Engine, CLI, containerd, and Docker Compose packages:
sudo yum remove docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

Images, containers, volumes, or custom configuration files on your host aren't automatically removed. To delete all images, containers, and volumes:

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd


# Install Docker Engine on Debian

Uninstall old versions

Before you can install Docker Engine, you need to uninstall any conflicting packages.

Distro maintainers provide unofficial distributions of Docker packages in their repositories. You must uninstall these packages before you can install the official version of Docker Engine.

The unofficial packages to uninstall are:

docker.io
docker-compose
docker-doc
podman-docker
Moreover, Docker Engine depends on containerd and runc. Docker Engine bundles these dependencies as one bundle: containerd.io. If you have installed the containerd or runc previously, uninstall them to avoid conflicts with the versions bundled with Docker Engine.

for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

Images, containers, volumes, and networks stored in /var/lib/docker/ aren't automatically removed when you uninstall Docker. If you want to start with a clean installation, and prefer to clean up any existing data, read the uninstall Docker Engine section.

# Installation methods

Install using the apt repository
# Add Docker's official GPG key:

sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
#
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# To install latest version 

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Uninstall Docker Engine

Uninstall the Docker Engine, CLI, containerd, and Docker Compose packages:

sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras

Images, containers, volumes, or custom configuration files on your host aren't automatically removed. To delete all images, containers, and volumes:

sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd

# How to change the default path of Docker config.

sudo systemctl stop docker

vi /etc/docker/daemon.json
And add the following to tell docker to put all its files in this folder, e.g:

{
  "/var/lib/docker":"/mnt/cryptfs/docker"
}
and save.

sudo systemctl start 

if you want give access to user.

# sudo chmod -a -G docker $username




