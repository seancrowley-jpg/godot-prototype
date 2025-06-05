extends VehicleBody3D

const MAX_STEER_ANGLE = 0.8

@export_group("Stats")
@export var engine_power = 150
@export var brake_power = 12
@export_group("Nodes")
@export var interact_area_3d : Area3D
@export var camera_3d : Camera3D
@export var player : Player
@export var player_drive_pos: Marker3D
@export var exit_timer: Timer
@export var collision: CollisionShape3D
@export var front_pos: Marker3D

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
		player.in_vehicle = true
		player.player_collision.disabled  = true

func exit_vehicle():
	if active && can_exit:
		if Input.is_action_just_pressed("interact"):
			active = false
			camera_3d.current = false
			can_exit = false
			player.in_vehicle = false
			player.rotation = Vector3.ZERO
			player.player_collision.disabled  = false
			
func vehicle_movement(delta):
	steering = move_toward(steering, Input.get_axis("right","left") * MAX_STEER_ANGLE, delta * 2.5)
	brake = Input.get_action_strength("sprint") * brake_power
	engine_force = Input.get_axis("back","forward") * engine_power
	player.look_at_from_position(player_drive_pos.global_position, front_pos.global_position)
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
