#!/bin/bash

# Workaround for permissions problems with `jenkins` user inside the container
cp -R . ~/status-node
cd ~/status-node

git clean -dfx && rm -rf vendor/* && make -j4 V=1 update
make V=1 pkg

# Make AppImage build accessible to the docker host
cd - && cp -R ~/status-node/pkg .
chmod -R 775 ./pkg
