#!/usr/bin/env bash

pytorchver=129

while getopts "v:" opt; do
  case $opt in
    v) pytorchver=$OPTARG ;;
    *) echo "Invalid option" ;;
  esac
done

echo "Target Pytorch Version: $pytorchver"


source /opt/ros/jazzy/setup.sh
export EXTENSION_DIR=/home/user/slicer/packages
xvfb-run --auto-servernum /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer --no-main-window --no-splash --python-script /home/user/slicer/update-slicer-pytorch.py $pytorchver; exit 0
