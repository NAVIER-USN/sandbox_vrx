ARG FROM_IMAGE=ros:noetic

# multi-stage for building
FROM $FROM_IMAGE AS builder

ENV DIST=noetic
ENV GAZ=gazebo11

ARG DEBIAN_FRONTEND=noninteractive
RUN export DEBIAN_FRONTEND=noninteractive

# install ros dependencies
RUN apt-get update && apt-get full-upgrade -y && apt-get install -y \
      build-essential cmake cppcheck curl git gnupg libeigen3-dev libgles2-mesa-dev lsb-release pkg-config protobuf-compiler qtbase5-dev python3-dbg python3-pip python3-venv ruby software-properties-common wget \
      ros-$ROS_DISTRO-foxglove-bridge \
    && echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list \
    && apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 \
    && echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list \
    && wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add - \
    && apt-get update \
    && apt-get install -y ${GAZ} lib${GAZ}-dev ros-${DIST}-xacro ros-${DIST}-nmea-msgs ros-${DIST}-gazebo-plugins \
      ros-${DIST}-gazebo-ros ros-${DIST}-hector-gazebo-plugins ros-${DIST}-joy ros-${DIST}-joy-teleop \
      ros-${DIST}-key-teleop ros-${DIST}-robot-localization ros-${DIST}-robot-state-publisher ros-${DIST}-joint-state-publisher \
      ros-${DIST}-rviz ros-${DIST}-ros-base ros-${DIST}-teleop-tools ros-${DIST}-teleop-twist-keyboard ros-${DIST}-velodyne-simulator \
      ros-${DIST}-xacro ros-${DIST}-rqt ros-${DIST}-rqt-common-plugins ros-${DIST}-foxglove-bridge \
    && rm -rf /var/lib/apt/lists/*


# multi-stage for developing
FROM builder AS dever

# edit apt for caching
RUN mv /etc/apt/apt.conf.d/docker-clean /etc/apt/

# install developer dependencies
RUN apt-get update && apt-get install -y \
      bash-completion \
      python3-pip \
      wget && \
    pip3 install \
      bottle \
      glances

# multi-stage for caddy
FROM caddy:builder AS caddyer

# build custom modules
RUN xcaddy build \
    --with github.com/caddyserver/replace-response

# multi-stage for visualizing
FROM dever AS visualizer

ENV ROOT_SRV /srv
RUN mkdir -p $ROOT_SRV

# install gzweb dependacies
RUN apt-get install -y --no-install-recommends \
      imagemagick \
      libboost-all-dev \
      libgazebo11-dev \
      libgts-dev \
      libjansson-dev \
      libtinyxml-dev \
      nodejs \
      npm \
      psmisc \
      xvfb

# clone gzweb
ENV GZWEB_WS /opt/gzweb
RUN apt-get install -y git
RUN git clone https://github.com/osrf/gzweb.git $GZWEB_WS

# setup gzweb
RUN cd $GZWEB_WS && . /usr/share/gazebo/setup.sh && \
    GAZEBO_MODEL_PATH=$GAZEBO_MODEL_PATH:$(find /opt/ros/$ROS_DISTRO/share \
      -mindepth 1 -maxdepth 2 -type d -name "models" | paste -s -d: -) && \
    sed -i "s|var modelList =|var modelList = []; var oldModelList =|g" gz3d/src/gzgui.js && \
    xvfb-run -s "-screen 0 1280x1024x24" ./deploy.sh -m local && \
    ln -s $GZWEB_WS/http/client/assets http/client/assets/models && \
    ln -s $GZWEB_WS/http/client $ROOT_SRV/gzweb

# patch gzsever
RUN GZSERVER=$(which gzserver) && \
    mv $GZSERVER $GZSERVER.orig && \
    echo '#!/bin/bash' > $GZSERVER && \
    echo 'exec xvfb-run -s "-screen 0 1280x1024x24" gzserver.orig "$@"' >> $GZSERVER && \
    chmod +x $GZSERVER

# setup foxglove
# Use custom fork until PR is merged:
# https://github.com/foxglove/studio/pull/5987
# COPY --from=ghcr.io/foxglove/studio /src $ROOT_SRV/foxglove
COPY --from=ghcr.io/ruffsl/foxglove_studio@sha256:8a2f2be0a95f24b76b0d7aa536f1c34f3e224022eed607cbf7a164928488332e /src $ROOT_SRV/foxglove

# install web server
COPY --from=caddyer /usr/bin/caddy /usr/bin/caddy

# download media files
RUN mkdir -p $ROOT_SRV/media && cd /tmp && \
    export ICONS="icons.tar.gz" && wget https://github.com/ros-planning/navigation2/files/11506823/$ICONS && \
    echo "cae5e2a5230f87b004c8232b579781edb4a72a7431405381403c6f9e9f5f7d41 $ICONS" | sha256sum -c && \
    tar xvz -C $ROOT_SRV/media -f $ICONS && rm $ICONS

