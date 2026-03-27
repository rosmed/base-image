#!/usr/bin/env bash

source /opt/ros/jazzy/setup.bash

# if the file exists, then run it
if [ -f /home/user/slicer/Slicer-5.10/Slicer ]; then
    /home/user/slicer/Slicer-5.10/Slicer  --no-main-window --no-splash --python-script /home/user/slicer/install-module.py
elif [ -f /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer ]; then
    /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer  --no-main-window --no-splash --python-script /home/user/slicer/install-module.py
fi
