#!/bin/bash

# This script assumes $PWD is the same dir in which this script is located

# Helps avoid permissions problems with `jenkins` user in docker container when
# making a local packaged build
git clean -dfx

docker run -it --rm \
  --cap-add SYS_ADMIN \
  --security-opt apparmor:unconfined \
  --device /dev/fuse \
  -u jenkins:$(getent group $(whoami) | cut -d: -f3) \
  -v "${PWD}:/status-node" \
  -w /status-node \
  statusteam/status-node-build:0.1.0 \
  ./docker-linux-app-image.sh
