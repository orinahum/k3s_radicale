#!/bin/bash
latest=3.2.3
stable=3.2.2
test=master

# Docker Hub repository
DOCKER_USERNAME="orinahum1982"
IMAGE_NAME="radicale"
DOCKER_TOKEN=""

# Login Docker Hub
# echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Build and tag images for different versions
docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:latest --build-arg VERSION=$latest .
docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:stable --build-arg VERSION=$stable .
docker build -f Dockerfile -t $DOCKER_USERNAME/$IMAGE_NAME:test --build-arg VERSION=$test .

# # Push the images to Docker Hub
# docker push $DOCKER_USERNAME/$IMAGE_NAME:latest
# docker push $DOCKER_USERNAME/$IMAGE_NAME:stable
# docker push $DOCKER_USERNAME/$IMAGE_NAME:test

# # Logout Docker Hub
# docker logout
