DIST=noetic
GAZ=gazebo11
DEBIAN_FRONTEND=noninteractive

sudo apt update
sudo apt full-upgrade
sudo apt install -y build-essential cmake cppcheck curl git gnupg libeigen3-dev libgles2-mesa-dev lsb-release pkg-config protobuf-compiler qtbase5-dev python3-dbg python3-pip python3-venv ruby software-properties-common wget 
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt update
sudo apt install -y ${GAZ} lib${GAZ}-dev ros-${DIST}-xacro ros-${DIST}-nmea-msgs ros-${DIST}-gazebo-plugins \
     ros-${DIST}-gazebo-ros ros-${DIST}-hector-gazebo-plugins ros-${DIST}-joy ros-${DIST}-joy-teleop \
     ros-${DIST}-key-teleop ros-${DIST}-robot-localization ros-${DIST}-robot-state-publisher ros-${DIST}-joint-state-publisher \
     ros-${DIST}-rviz ros-${DIST}-ros-base ros-${DIST}-teleop-tools ros-${DIST}-teleop-twist-keyboard ros-${DIST}-velodyne-simulator \
     ros-${DIST}-xacro ros-${DIST}-rqt ros-${DIST}-rqt-common-plugins


echo copying models to gzweb directory
cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/vrx_gazebo/models/* /opt/gzweb/http/client/assets/
cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/wamv_description/models/* /opt/gzweb/http/client/assets/
cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/wamv_gazebo/models/gps /opt/gzweb/http/client/assets/
cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/wave_gazebo/world_models/ocean_waves /opt/gzweb/http/client/assets/
echo models copied