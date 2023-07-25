#echo "/usr/share/gazebo-11/setup.sh" >> ~/.bashrc
#echo "source /workspaces/sandbox_vrx/vrx_navier/devel/setup.bash" >> ~/.bashrc

echo copying models to gzweb directory
cp -r /workspaces/sandbox_vrx/vrx_navier/src/vrx/vrx_gazebo /opt/gzweb/http/client/assets/
cp -r /workspaces/sandbox_vrx/vrx_navier/src/vrx/vrx_gazebo/models/* /opt/gzweb/http/client/assets/

cp -r /workspaces/sandbox_vrx/vrx_navier/src/vrx/wamv_description/models/* /opt/gzweb/http/client/assets/
cp -r /workspaces/sandbox_vrx/vrx_navier/src/vrx/wamv_description /opt/gzweb/http/client/assets/

cp -r /workspaces/sandbox_vrx/vrx_navier/src/vrx/wamv_gazebo/models/gps /opt/gzweb/http/client/assets/

cp -r /workspaces/sandbox_vrx/vrx_navier/src/vrx/wave_gazebo/world_models/ocean_waves /opt/gzweb/http/client/assets/
cp -r /workspaces/sandbox_vrx/vrx_navier/src/vrx/wave_gazebo /opt/gzweb/http/client/assets/

echo models copied