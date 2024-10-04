class_name Player
extends CharacterBody3D

@export var sens_horizontal = 0.5
@export var sens_vertical = 0.5
@export var crouch_shapecast: Node3D
@export var cover_raycast_left: Node3D
@export var cover_raycast_middle: Node3D
@export var cover_raycast_right: Node3D
@export var cover_shapecast: Node3D
@export var ledge_raycast_1: Node3D
@export var ledge_raycast_2: Node3D

@onready 
var animation_tree = $AnimationTree
@onready var state_label = $StateText
@onready var playback  = animation_tree["parameters/playback"]
@onready var visuals = $visuals
@onready var camera_mount = $camera_mount
@onready var camera_3d = $camera_mount/SpringArm3D/Camera3D
@onready var spring_arm_3d = $camera_mount/SpringArm3D
@onready var alt_cam_pos = $alt_cam_pos
@onready var default_cam_pos = $default_cam_pos
@onready var collision = $PlayerCollisionShape3D


@export var f_view = {"Default": 75.0, "Zoom": 50.0}
var cam_switched = false
var ADS_LERP = 20
var is_crouching = false
var idle_animations = ["idle 1","idle 3","idle 2"]

@onready
var state_machine = $state_machine

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_tree.active = true
	crouch_shapecast.add_exception($".")

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	zoom(delta)
	cam_switch(delta)
	#print("FPS " , (Engine.get_frames_per_second()))
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * sens_horizontal))
		visuals.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * sens_vertical))
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-89), deg_to_rad(89))

func movement(x, z):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var movement = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if movement:
		visuals.rotation.y = lerp_angle(visuals.rotation.y, atan2(-input_dir.x, -input_dir.y), .25)
	velocity.x = movement.x * x
	velocity.z = movement.z * z
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
		

func crouch_collision():
	var t := create_tween()
	t.tween_property(collision,"position:y",0.583,0.001)
	t.tween_property(collision,"shape:height",1.12,0.001)
	
func stand_collision():
	var t := create_tween()
	t.tween_property(collision,"position:y",0.858,0.001)
	t.tween_property(collision,"shape:height",1.677,0.001)
	
