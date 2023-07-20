#!/bin/bash

# Immediately catch all errors
set -eo pipefail

# Uncomment for debugging
# set -x
# env

git config --global --add safe.directory "*"

./update-content-command.sh


echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc