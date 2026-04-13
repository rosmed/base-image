ARG VAST_BASE=rosmed/linux-desktop-slim:cuda-12.9-ubuntu24.04-2026-03-01-slim

FROM ${VAST_BASE}

# Maintainer details
LABEL org.opencontainers.image.source="https://github.com/vastai/"
LABEL org.opencontainers.image.description="Linux desktop container image with ROS 2 Jazzy, suitable for Vast.ai."
LABEL maintainer="Vast.ai Inc <contact@vast.ai>"

WORKDIR /home/user

#
# Install CUDA toolkit
#

USER root
RUN apt-get update && apt install -y cuda-toolkit-12-9


################################################################################
# Install ROS 2 Jazzy Jalisco
# See https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html
################################################################################

#
# Set locale
#
RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8

#
# Enable required repositories and install ROS 2 apt source
#
RUN apt-get install -y software-properties-common \
    && add-apt-repository universe \
    && apt-get update && apt-get install -y curl \
    && export ROS_APT_SOURCE_VERSION=$(curl -s https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest | grep -F "tag_name" | awk -F'"' '{print $4}') \
    && curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" \
    && dpkg -i /tmp/ros2-apt-source.deb \
    && rm -f /tmp/ros2-apt-source.deb \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#
# Install ROS 2 Jazzy
#
RUN apt-get update \
    && apt-get install -y ros-dev-tools \
    && apt-get install -y ros-jazzy-desktop \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#
# Additional ROS 2 packages
#
RUN apt-get update \
    && apt-get install -y \
        python3-numpy \
        python3-vcstool \
        python3-colcon-common-extensions \
        python3-pykdl \
        libxml2-dev \
        libraw1394-dev \
        libncurses5-dev \
        qtcreator \
        swig \
        sox \
        espeak \
        cmake-curses-gui \
        cmake-qt-gui \
        subversion \
        gfortran \
        libcppunit-dev \
        libbluetooth-dev \
        libxcursor-dev \
        libxinerama-dev \
        libasound2-dev \
        libusb-1.0.0-dev \
        ros-jazzy-joint-state-publisher \
        ros-jazzy-joint-state-publisher-gui \
        ros-jazzy-xacro \
        ros-jazzy-object-recognition-msgs \
        ros-jazzy-moveit \
        ros-jazzy-ros-gz \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#
# Source ROS 2 setup in bash sessions
#
RUN echo "source /opt/ros/jazzy/setup.bash" >> /etc/bash.bashrc


################################################################################
# Libraries for ISMR 2021 Tutorial
################################################################################

#
# Prerequisite for 3D Slicer
#
RUN apt-get update \
    && apt-get install -y \
        qtmultimedia5-dev \
        qttools5-dev \
        libqt5xmlpatterns5-dev \
        libqt5svg5-dev \
        qtwebengine5-dev \
        qtscript5-dev \
        qtbase5-private-dev \
        libqt5x11extras5-dev \
        libxt-dev \
        libssl-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#WORKDIR /home/user
#USER user
#RUN mkdir igtl \
#    && cd igtl \
#    && git clone https://github.com/openigtlink/OpenIGTLink \
#    && mkdir OpenIGTLink-build \
#    && cd OpenIGTLink-build \
#    && cmake -DBUILD_SHARED_LIBS:BOOL=OFF -DBUILD_EXAMPLES:BOOL=ON ../OpenIGTLink \
#    && make

################################################################################
# 3D Slicer for ISMR 2021 Tutorial
################################################################################

WORKDIR /home/user
USER user

#
# Build 3D Slicer
#
RUN mkdir /home/user/slicer \
    && cd /home/user/slicer \
    && git clone --branch v5.10.0 https://github.com/slicer/Slicer \
    && mkdir Slicer-SuperBuild-Release \
    && cd Slicer-SuperBuild-Release \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_USE_SYSTEM_OpenSSL=ON ../Slicer \
    && make -j4


################################################################################
# Slicer Extensions for ISMR2025
################################################################################

WORKDIR /home/user
USER user

#
# SlicerOpenIGTLink
#
RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/openigtlink/SlicerOpenIGTLink \
    && mkdir SlicerOpenIGTLink-build \
    && cd SlicerOpenIGTLink-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build ../SlicerOpenIGTLink \
    && make -j4

#
# SlicerIGSIO
#

# NOTE: GPU volume reconstruction is turned off temporarily because CL/cl.hpp is not available on Ubuntu 24.04
# Use -DSlicerIGSIO_USE_GPU=OFF (not IGSIO_USE_GPU_RECONSTRUCT which doesn't exist).
# The CUDA base image provides OpenCL so SlicerIGSIO_USE_GPU defaults to ON unless explicitly disabled.

#USER root
#RUN apt update \
#    && apt install -y opencl-clhpp-headers \
#    && apt install -y opencl-headers \
#    && apt install -y ocl-icd-libopencl1 \
#    && apt install -y ocl-icd-opencl-dev
#RUN apt update && apt install -y nvidia-opencl-dev
#USER user

RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/IGSIO/SlicerIGSIO\
    && mkdir SlicerIGSIO-build \
    && cd SlicerIGSIO-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build -DSlicerIGSIO_USE_GPU=OFF ../SlicerIGSIO \
    && make -j4

#
# SlicerIGT
#
RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/SlicerIGT/SlicerIGT\
    && mkdir SlicerIGT-build \
    && cd SlicerIGT-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build -DSlicerIGSIO_DIR:PATH=/home/user/slicer/modules/SlicerIGSIO-build/inner-build ../SlicerIGT \
    && make -j4

#
# SlicerDevelopmentToolbox
#
RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/QIICR/SlicerDevelopmentToolbox \
    && mkdir SlicerDevelopmentToolbox-build \
    && cd SlicerDevelopmentToolbox-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build ../SlicerDevelopmentToolbox \
    && make -j4


#
# SlicerNNInteractive
#
RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/coendevente/SlicerNNInteractive \
    && mkdir SlicerNNInteractive-build \
    && cd SlicerNNInteractive-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build ../SlicerNNInteractive \
    && make -j4

#
# SlicerNNUnet
#
RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/KitwareMedical/SlicerNNUnet \
    && mkdir SlicerNNUnet-build \
    && cd SlicerNNUnet-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build ../SlicerNNUnet \
    && make -j4

#
# SlicerPyTorch
#
RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/fepegar/SlicerPyTorch \
    && mkdir SlicerPyTorch-build \
    && cd SlicerPyTorch-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build ../SlicerPyTorch \
    && make -j4

#
# SlicerPythonTestRunner
#
RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/KitwareMedical/SlicerPythonTestRunner \
    && mkdir SlicerPythonTestRunner-build \
    && cd SlicerPythonTestRunner-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build ../SlicerPythonTestRunner \
    && make -j4

#
# SlicerTotalSegmentator
#
RUN mkdir -p /home/user/slicer/modules \
    && cd /home/user/slicer/modules \
    && git clone https://github.com/lassoan/SlicerTotalSegmentator \
    && mkdir SlicerTotalSegmentator-build \
    && cd SlicerTotalSegmentator-build \
    && cmake -DCMAKE_BUILD_TYPE:STRING=Release -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build ../SlicerTotalSegmentator \
    && make -j4


################################################################################
# Build packages
################################################################################

WORKDIR /home/user
USER user

##
## Slicer Package
##
#RUN cd /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build \
#    && make package \
#    && mkdir -p /home/user/slicer/packages \
#    && mv _CPack_Packages/linux-amd64/TGZ/Slicer*.tar.gz /home/user/slicer/packages

#
# SlicerOpenIGTLink
#
RUN cd /home/user/slicer/modules \
    && cd SlicerOpenIGTLink-build \
    && cd inner-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages

#
# SlicerIGSIO
#
RUN cd /home/user/slicer/modules \
    && cd SlicerIGSIO-build \
    && cd inner-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages


#
# SlicerIGT
#
RUN cd /home/user/slicer/modules \
    && cd SlicerIGT-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages

#
# SlicerDevelopmentToolbox
#
RUN cd /home/user/slicer/modules \
    && cd SlicerDevelopmentToolbox-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages

#
# SlicerNNInteractive
#
RUN cd /home/user/slicer/modules \
    && cd SlicerNNInteractive-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages

#
# SlicerNNUnet
#
RUN cd /home/user/slicer/modules \
    && cd SlicerNNUnet-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages

#
# SlicerPyTorch
#
RUN cd /home/user/slicer/modules \
    && cd SlicerPyTorch-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages

#
# SlicerPythonTestRunner
#
RUN cd /home/user/slicer/modules \
    && cd SlicerPythonTestRunner-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages

#
# SlicerTotalSegmentator
#
RUN cd /home/user/slicer/modules \
    && cd SlicerTotalSegmentator-build \
    && make package \
    && mkdir -p /home/user/slicer/packages \
    && mv *.tar.gz /home/user/slicer/packages

#
# Build SlicerROS2
#
RUN mkdir -p /home/user/ros2_ws/src \
    && cd /home/user/ros2_ws/src \
    #&& git clone https://github.com/jhu-cisst/ros2_cisst_msgs.git cisst_msgs \ # Installed as part of dVRK/ciasst
    && git clone https://github.com/jhu-saw/ros2_sensable_omni_model \
    && git clone https://github.com/rosmed/slicer_ros2_module \
    && cd /home/user/ros2_ws \
    && /bin/bash -c 'source /opt/ros/jazzy/setup.sh; colcon build --cmake-args -DSlicer_DIR:PATH=/home/user/slicer/Slicer-SuperBuild-Release/Slicer-build -DCMAKE_BUILD_TYPE=Release'

#
# Package SlicerROS2
#
RUN mkdir -p /home/user/slicer/ \
    && mkdir -p /home/user/slicer/packages \
    && cd /home/user/slicer/packages \
    && /bin/bash -c 'source /opt/ros/jazzy/setup.sh; python3 /home/user/ros2_ws/src/slicer_ros2_module/do-release.py -b /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build -v 1.0'


#
# Install 3D Slicer Extensions
#
WORKDIR /home/user
USER user
COPY slicer/install-extension.py /home/user/slicer
COPY slicer/install-module.py /home/user/slicer
COPY slicer/update-slicer-pytorch.py /home/user/slicer
COPY slicer/start-slicer-ros2.bash /home/user
COPY slicer/setup-slicer.bash /home/user
COPY slicer/update-slicer-pytorch.bash /home/user

WORKDIR /home/user
USER root
RUN cd /home/user \
    && chown user slicer/install-extension.py \
    && chown user slicer/install-module.py \
    && chown user slicer/update-slicer-pytorch.py \
    && chown user start-slicer-ros2.bash \
    && chown user setup-slicer.bash \
    && chown user update-slicer-pytorch.bash

USER user
RUN cd /home/user \
    && chmod 755 start-slicer-ros2.bash \
    && chmod 755 setup-slicer.bash \
    && chmod 755 update-slicer-pytorch.bash

USER user
RUN sudo -u user /bin/bash -c 'source /opt/ros/jazzy/setup.sh; export EXTENSION_DIR=/home/user/slicer/packages; xvfb-run --auto-servernum /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer --no-main-window --no-splash --python-script /home/user/slicer/install-extension.py; exit 0'
RUN sudo -u user /bin/bash -c 'source /opt/ros/jazzy/setup.sh; export EXTENSION_DIR=/home/user/slicer/packages; xvfb-run --auto-servernum /home/user/slicer/Slicer-SuperBuild-Release/Slicer-build/Slicer --no-main-window --no-splash --python-script /home/user/slicer/update-slicer-pytorch; exit 0'

#
# Install nnInteractive server
#
# NOTE: "nnunetv2<2.7" option is added as the current nninteractive-slicer-server is not compatible with the latest API. (April 9, 2026)
#

#WORKDIR /home/user
#USER user
#RUN /bin/bash -c 'source /home/user/.bashrc; uv pip install nninteractive-slicer-server "nnunetv2<2.7"; echo "export LD_LIBRARY_PATH=/venv/main/lib/python3.12/site-packages/nvidia/cudnn/lib:$LD_LIBRARY_PATH" >> /home/user/.bashrc'
