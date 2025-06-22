#!/bin/bash
set -e

IMAGE_NAME=yocto-builder

echo "🛠️ Building Docker image: $IMAGE_NAME..."
docker build -t $IMAGE_NAME .
echo "✅ Image built successfully."

