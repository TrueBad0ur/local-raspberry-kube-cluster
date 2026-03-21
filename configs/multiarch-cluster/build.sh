#!/bin/bash
set -e

IMAGE="truebad0ur/multiarch-demo"
TAG="${1:-latest}"

# Ensure buildx builder with multi-platform support exists
if ! docker buildx inspect multiarch-builder &>/dev/null; then
  docker buildx create --name multiarch-builder --driver docker-container --bootstrap
fi
docker buildx use multiarch-builder

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  --tag "${IMAGE}:${TAG}" \
  --push \
  ./app

echo ""
echo "Pushed: ${IMAGE}:${TAG}"
echo "Manifest:"
docker buildx imagetools inspect "${IMAGE}:${TAG}"
