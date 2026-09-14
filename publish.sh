#!/bin/bash -ex

VERSION="$1"

docker build --label org.opencontainers.image.version=$VERSION -t autonomouslogic/claude-container:$VERSION .
docker tag autonomouslogic/claude-container:$VERSION autonomouslogic/claude-container:latest
docker push autonomouslogic/claude-container:$VERSION
docker push autonomouslogic/claude-container:latest
