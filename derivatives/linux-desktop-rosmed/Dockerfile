ARG VAST_BASE=rosmed/linux-desktop-slim:cuda-12.9-ubuntu24.04-2026-03-24-slim

FROM ${VAST_BASE}

# Maintainer details
LABEL org.opencontainers.image.source="https://github.com/vastai/"
LABEL org.opencontainers.image.description="Linux desktop container image with ROS 2 Jazzy, suitable for Vast.ai."
LABEL maintainer="Vast.ai Inc <contact@vast.ai>"

WORKDIR /home/user

################################################################################
# Install ROS 2 Jazzy Jalisco
# See https://docs.ros.org/en/jazzy/Installation/Ubuntu-Install-Debs.html
################################################################################

#
# Set locale
#
RUN apt-get update && apt-get install -y locales \
    && locale-gen en_US en_US.UTF-8 \
    && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

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
    && rm -f /tmp/ros2-apt-source.deb

#
# Install ROS 2 Jazzy
#
RUN apt-get update \
    && apt-get install -y ros-dev-tools \
    && apt-get upgrade -y \
    && apt-get install -y ros-jazzy-desktop \
    && apt-get install -y ros-jazzy-ros-base

#
# Additional ROS 2 packages
#
RUN apt-get update \
    && apt-get install -y \
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
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#
# Source ROS 2 setup in bash sessions
#
RUN echo "source /opt/ros/jazzy/setup.bash" >> /etc/bash.bashrc
