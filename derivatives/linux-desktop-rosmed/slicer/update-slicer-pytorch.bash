#!/usr/bin/env bash


source /opt/ros/jazzy/setup.sh
export EXTENSION_DIR=/home/user/slicer/packages
xvfb-run --auto-servernum /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer --no-main-window --no-splash --python-script /home/user/slicer/install-pytorch.py; exit 0
