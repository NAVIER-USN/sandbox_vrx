DIST=noetic
GAZ=gazebo11

echo copying models to gzweb directory
cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/vrx_gazebo /opt/gzweb/http/client/assets/
cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/vrx_gazebo/models/* /opt/gzweb/http/client/assets/

cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/wamv_description/models/* /opt/gzweb/http/client/assets/
cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/wamv_description /opt/gzweb/http/client/assets/

cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/wamv_gazebo/models/gps /opt/gzweb/http/client/assets/

cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/wave_gazebo/world_models/ocean_waves /opt/gzweb/http/client/assets/
cp -r /opt/overlay_ws/src/sandbox/vrx_navier/src/vrx/wave_gazebo /opt/gzweb/http/client/assets/



echo models copied