extends VehicleBody3D
@onready var rear_vehicle_wheel_3d = $Rear_VehicleWheel3D
@onready var rear_vehicle_wheel_3d_2 = $Rear_VehicleWheel3D2

func _physics_process(delta):
	rear_vehicle_wheel_3d.engine_force += .1
	rear_vehicle_wheel_3d_2.engine_force += .1
	
