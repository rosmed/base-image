#!/usr/bin/env bash

source /opt/ros/jazzy/setup.bash

# if the file exists, then run it
if [ -f /home/user/slicer/Slicer-5.10/Slicer ]; then
    /home/user/slicer/Slicer-5.10/Slicer
elif [ -f /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer ]; then
    SLICER_NV_LIB_PATH=/home/user/slicer/Slicer-SuperBuild-Release/python-install/lib/python3.12/site-packages/nvidia
    export LD_LIBRARY_PATH=$SLICER_NV_LIB_PATH/cudnn/lib:$SLICER_NV_LIB_PATH/cublas/lib:$LD_LIBRARY_PATH
    /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer
fi
