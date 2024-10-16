class_name Player
extends CharacterBody3D

@export_group("Player Stats")
@export var sens_horizontal = 0.5
@export var sens_vertical = 0.5
@export var fall_acceleration: float = 50
@export var f_view = {"Default": 75.0, "Zoom": 50.0}
@export var jump_force: float = 20
@export var acceleration: float = 30.0
@export var sprint_speed: float = 10
@export var roll_speed: float = 12

@export_group("Nodes")
@export var crouch_shapecast: Node3D
@export var cover_raycast_left: Node3D
@export var cover_raycast_middle: Node3D
@export var cover_raycast_right: Node3D
@export var cover_shapecast: Node3D
@export var ledge_raycast_1: Node3D
@export var ledge_raycast_2: Node3D
@export var raycast_timer: Node
@export var stick_point_holder: Node3D
@export var stick_point: Node3D
@export var wall_check_ray: Node3D
@export var animation_tree = Node3D
@export var state_label = Node3D
@export var player_collision = Node3D
@export var alt_cam_pos = Node3D
@export var default_cam_pos = Node3D
@export var ray_casts = Node3D

@onready var playback  = animation_tree["parameters/playback"]
@onready var visuals = $visuals
@onready var camera_mount = $camera_mount
@onready var camera_3d = $camera_mount/SpringArm3D/Camera3D
@onready var spring_arm_3d = $camera_mount/SpringArm3D
@onready var state_machine = $state_machine
@onready var remote_transform_3d = $RemoteTransform3D

var cam_switched = false
var ADS_LERP = 20
var is_crouching = false
var idle_animations = ["idle 1","idle 3","idle 2"]
var left_right_lock := false
var on_ledge := false


func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_tree.active = true
	crouch_shapecast.add_exception($".")
	cover_shapecast.add_exception($".")


func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
			camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-89), deg_to_rad(89))
			rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
			remote_transform_3d.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	ray_casts.global_basis = visuals.global_basis
	if !left_right_lock:
		remote_transform_3d.update_rotation = true
	else:
		remote_transform_3d.update_rotation = false


func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	zoom(delta)
	cam_switch(delta)
	print("FPS " , (Engine.get_frames_per_second()))

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event.is_action_pressed("left click"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func movement(speed, delta):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var movement = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if movement:
		remote_transform_3d.rotation.y = lerp_angle(remote_transform_3d.rotation.y, atan2(-input_dir.x, -input_dir.y), 15 * delta)

	velocity = velocity.move_toward(movement * speed, delta * acceleration)
	
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta
	
	
	move_and_slide()

func move_left_right(raycast: Node3D):
	#Enables movement of character to the left or right of the object its facing
	move_and_slide()
	var rot = -(atan2(raycast.get_collision_normal().z, raycast.get_collision_normal().x) - PI/2)
	var h_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity = Vector3(h_input,0,0).rotated(Vector3.UP,rot).normalized()

func zoom(delta):
	if Input.is_action_pressed("zoom"):
		camera_3d.fov = lerp(camera_3d.fov, f_view["Zoom"], ADS_LERP * delta)
	else :
		camera_3d.fov = lerp(camera_3d.fov, f_view["Default"], ADS_LERP * delta )

func cam_switch(delta):
	if Input.is_action_just_pressed("switch_cam"):
		if cam_switched:
			cam_switched = false
		else:
			cam_switched = true
		
	# cam transition
	if cam_switched:
		spring_arm_3d.transform = spring_arm_3d.transform.interpolate_with(alt_cam_pos.transform, delta * 2 )

	elif !cam_switched:
		spring_arm_3d.transform = spring_arm_3d.transform.interpolate_with(default_cam_pos.transform, delta * 2 )
	

func crouch_collision():
	var t := create_tween()
	t.tween_property(player_collision,"position:y",0.575,0)
	t.tween_property(player_collision,"shape:height",1.5,0)

func stand_collision():
	var t := create_tween()
	t.tween_property(player_collision,"position:y",0.84,0)
	t.tween_property(player_collision,"shape:height",2.191,0)

func disbable_ledge_raycasts():
	ledge_raycast_1.enabled = false
	ledge_raycast_2.enabled = false

func _enable_raycast_timer_timeout():
	#enables ledge detection ray casts
	ledge_raycast_1.enabled = true
	ledge_raycast_2.enabled = true
	on_ledge = false

func rotate_player_visuals(raycast: Node3D):
	var rot = -(atan2(raycast.get_collision_normal().z, raycast.get_collision_normal().x) - PI/2)
	visuals.rotation.y = lerp_angle(rotation.y, rot, 1)
	pass

func pull_player_toward_obj(raycast: Node3D):
	if!cover_shapecast.is_colliding():
		var obj = raycast.get_collision_point()
		velocity = Vector3((position.x - obj.x) * -1, 0, (position.z - obj.z) * -1)
	else:
		velocity = Vector3.ZERO
	
