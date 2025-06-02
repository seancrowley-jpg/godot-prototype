extends VehicleBody3D

const MAX_STEER = 0.8
const ENGINE_POWER = 300

@export var interact_area_3d : Area3D
@export var camera_3d : Camera3D
@export var player : Player
@export var player_pos: Marker3D
var overlapping : bool = false
var active : bool = false

func _physics_process(delta):
	if overlapping && Input.is_action_just_pressed("interact"):
		active = true
		camera_3d.current = true
	if active:
		vehicle_movement(delta)
		

func vehicle_movement(delta):
	steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER, delta * 2.5)
	engine_force = Input.get_axis("back","forward") * ENGINE_POWER
	player.position = player_pos.global_position
	

func _on_interact_area_3d_body_entered(body):
	if body.name == "Player":
		overlapping = true

func _on_interact_area_3d_body_exited(body):
	if body.name == "Player":
		overlapping = false
