#!/bin/bash

# Docker Hub repository
DOCKER_USERNAME="orinahum1982"
IMAGE_NAME="radicale"
DOCKER_TOKEN=""

# Login Docker Hub
echo "$DOCKER_TOKEN" | docker login -u "$DOCKER_USERNAME" --password-stdin

# Versions
VERSIONS=("latest" "stable" "test")

# Loop versions and build/push
for VERSION in "${VERSIONS[@]}"
do
    echo "Building and pushing $VERSION version..."

    # Dockerfile based on version
    if [ "$VERSION" == "latest" ]; then
        DOCKERFILE="Dockerfile-latest"
    elif [ "$VERSION" == "stable" ]; then
        DOCKERFILE="Dockerfile-stable"
    else
        DOCKERFILE="Dockerfile-test"
    fi

    # Build image
    docker build -f $DOCKERFILE -t $DOCKER_USERNAME/$IMAGE_NAME:$VERSION .

    # Push image
    docker push $DOCKER_USERNAME/$IMAGE_NAME:$VERSION
done

# Logout Docker Hub
docker logout
