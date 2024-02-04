class_name Player
extends CharacterBody3D

@export var sens_horizontal = 0.5
@export var sens_vertical = 0.5
#@onready
#var animations = $animations
@onready 
var animation_tree = $AnimationTree
@onready var playback  = animation_tree["parameters/playback"]
@onready var visuals = $visuals
@onready var camera_mount = $camera_mount
@onready var camera_3d = $camera_mount/SpringArm3D/Camera3D
@onready var spring_arm_3d = $camera_mount/SpringArm3D
@onready var alt_cam_pos = $alt_cam_pos
@onready var default_cam_pos = $default_cam_pos

@export var f_view = {"Default": 75.0, "Zoom": 50.0}
var cam_switched = false
var ADS_LERP = 20

@onready
var state_machine = $state_machine

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_tree.active = true

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	zoom(delta)
	cam_switch(delta)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func movement(move_speed):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var movement = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if movement:
		visuals.rotation.y = lerp_angle(visuals.rotation.y, atan2(-input_dir.x, -input_dir.y), .25)
	velocity.x = movement.x * move_speed
	velocity.z = movement.z * move_speed
	move_and_slide()
	
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
