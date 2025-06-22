# RadarModule

# 🧰 BeagleBone Black Yocto Build Environment

This repository sets up a containerized Yocto build system for BeagleBone Black using the `kirkstone` release. It includes a Docker container, automated setup script, and all required layers.

## 🚀 Quickstart

1. **Build the Docker image**

   ./build-docker.sh

2. **Run the container**

   ./run-docker.sh

3. **Inside the container: Set up the Yocto environment**

   cd ~/yocto
   chmod +x setup-yocto.sh
   ./setup-yocto.sh

4. **Build the image**

   cd poky
   source oe-init-build-env build
   bitbake core-image-minimal

## 🗂 Project Layout

- setup-yocto.sh: Automates setup of required layers and build config
- build-docker.sh: Builds the Docker container image
- run-docker.sh: Launches an interactive container with your workspace
- yocto/: Your persistent build workspace (mounted into container)

## 🛠 Requirements

- Docker engine with --privileged support
- ~50 GB free disk space
- Host OS: Ubuntu 22.04 or 24.04 (see below for AppArmor caveat)

## ⚠️ Ubuntu 24.04 AppArmor Note

Ubuntu 24.04 restricts unprivileged user namespaces, which Yocto requires.

To allow BitBake to work, run this on your host machine:

   sudo apparmor_parser -R /etc/apparmor.d/unprivileged_userns

This disables the restrictive AppArmor profile that blocks Yocto builds.

## 📦 Building Complete? Flash the Image

Once the build completes, your image will be in:

   poky/build/tmp/deploy/images/beaglebone/

For flashing instructions, see flash-image.md (coming soon).

