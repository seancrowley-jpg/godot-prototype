extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 300

@export var interact_area_3d : Area3D
@export var camera_3d : Camera3D
@export var player : Player
@export var player_pos: Marker3D
@export var exit_timer: Timer

var overlapping : bool = false
var active : bool = false
var can_exit : bool = false

func _physics_process(delta):
	enter_vehicle(delta)
	exit_vehicle()
	
func enter_vehicle(delta):
	if overlapping && Input.is_action_just_pressed("interact") && !active:
		active = true
		exit_timer.start()
	if active:
		vehicle_movement(delta)
		camera_3d.current = true
		
func exit_vehicle():
	if active && can_exit:
		if Input.is_action_just_pressed("interact"):
			active = false
			camera_3d.current = false
			can_exit = false

func vehicle_movement(delta):
	steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER, delta * 2.5)
	engine_force = Input.get_axis("back","forward") * ENGINE_POWER
	player.position = player_pos.global_position
	#Stops vehcile from accelerating if player exits vehcile
	if Input.is_action_just_pressed("interact"):
		engine_force = 0

func _on_interact_area_3d_body_entered(body):
	if body.name == "Player":
		overlapping = true

func _on_interact_area_3d_body_exited(body):
	if body.name == "Player":
		overlapping = false

func _on_vehicle_timer_timeout():
	can_exit = true
