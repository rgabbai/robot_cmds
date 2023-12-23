# This code is assuming we activated docker "robot" image
# The entrypoint.sh was activated without ROBOT_ON variable.
# ROS project under repos/robot_ws was sourced: source ./install/setup.bash

# "robot" image contain the following compiled ROS components:
# poc_2w_Robot - Activate control infra - ROS control config and launch files  , robot description
# mpu6050
# diffdrive_arduino
# serial
# teleop_twist_joy/



# Activate ROS2 control node
# Activate camera to take high resolution 640x360 pictures
cd /repos/robot_ws
ros2 launch poc_2W_Robot launch_robot2.launch.py &
cp libonnxruntime.so.1.15.1 /usr/lib/.
cd ../cam_det_pub_node
./target/release/det_publisher -m high 


