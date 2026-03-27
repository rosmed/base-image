#!/usr/bin/env bash

source /opt/ros/jazzy/setup.bash

# if the file exists, then run it
if [ -f /home/user/slicer/Slicer-5.10/Slicer ]; then
    /home/user/slicer/Slicer-5.10/Slicer
elif [ -f /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer ]; then
    /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer
fi
