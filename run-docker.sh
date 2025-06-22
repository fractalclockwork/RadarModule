#!/bin/bash
set -e

IMAGE_NAME=yocto-builder
BUILD_DIR=$PWD/yocto-workdir

mkdir -p "$BUILD_DIR"

docker run --rm -it \
  --privileged \
  -v /dev:/dev \
  -v "$BUILD_DIR":/home/builder/yocto \
  -w /home/builder/yocto \
  $IMAGE_NAME

