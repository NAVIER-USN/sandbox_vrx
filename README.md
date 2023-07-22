# VRX simulation

## codespaces setup
### 1. Create codespace
Create and enter a new codespace for this repository by clicking on the blue "\<code>" button, then "create codespace on main". This will spin up a virtual machine on github's cloud, with all necessary developer tools and simulation dependencies ready to go

### 2. Set up workspace
navigate to the root of the ros workspace, then compile and source the environment.
```bash
source /opt/ros/noetic/setup.bash
cd /opt/overlay_ws/src/sandbox/vrx_navier
catkin_make
source devel/setup.bash
```

### 3. import gazebo models
To render the custom models in the simulation through gzweb, run the `setup_models.sh`  script:
```bash
cd /opt/overlay_ws/src/sandbox
./setup_models.sh
```
This will copy relevant simulation models in to the /opt/gzweb/http/client/assets directory, such that they can be viewed in the browser.

### 4. Start the simulation
```
roslaunch navier_bringup gzweb_bringup.launch
```

### 5. Set up and view visualizations
- To start gzweb, foxglove, glances and the PWA hub, run the "start visualizations" task by first entering the command palette (`ctrl+shift+p`), selecting `Task: run task` and `Start visualization`.

- From the `PORTS` panel, click the `Open in Browser` button for port `8080` forwarded from the container to view the visualization launcher page.

- Finally, play around with the various web apps using the launcher page.