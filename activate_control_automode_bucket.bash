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
cd /repos/robot_ws
ros2 launch poc_2W_Robot launch_robot2.launch.py &

# Activate camera detection pipe without, publish only detected info (do not publish images), use AI model A (default)
cp libonnxruntime.so.1.15.1 /usr/lib/.
cd ../cam_det_pub_node
./target/release/det_publisher -m none  -a A & 

# Activate MPU info
cd ../robot_ws/src/mpu6050
source install/setup.bash
rm mpu6050_calibration.json
ros2 run mpu6050 imu_publisher_node &
# Calibrate the mpu 
ros2 service call /calibrate_imu std_srvs/srv/Trigger "{}" 
# activate filter
ros2 run imu_filter_madgwick imu_filter_madgwick_node   --ros-args -p use_mag:=false -r /imu/data_raw:=/mpu6050/imu/data &

# Activate auto_mode
cd /repos/tracking_node
./target/release/auto_mode -o bucket &

