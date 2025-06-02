class_name Player
extends CharacterBody3D

@export_group("Player Stats")
@export var sens_horizontal: float = 0.5
@export var sens_vertical: float = 0.5
@export var fall_acceleration: float = 50
@export var f_view: Dictionary = {"Default": 75.0, "Zoom": 50.0}
@export var jump_force: float = 20
@export var acceleration: float = 30.0
@export var run_speed: float = 5
@export var sprint_speed: float = 10
@export var roll_speed: float = 12
@export var cover_move_speed: float = 1.5
@export var ledge_move_speed: float = 2
@export var crouch_move_speed: float = 2
@export var joy_stick_dead_zone: float = 0.1
@export var joy_stick_sens_horizontal: float = 2
@export var joy_stick_sens_vertical: float = 2

@export_group("Nodes")
@export var crouch_shapecast: ShapeCast3D
@export var cover_raycast_left: RayCast3D
@export var cover_raycast_middle: RayCast3D
@export var cover_raycast_right: RayCast3D
@export var crouch_cover_raycast_left: RayCast3D
@export var crouch_cover_raycast_middle: RayCast3D
@export var crouch_cover_raycast_right: RayCast3D
@export var cover_shapecast: ShapeCast3D
@export var ledge_raycast_1: RayCast3D
@export var ledge_raycast_2: RayCast3D
@export var raycast_timer: Timer
@export var stick_point_holder: Marker3D
@export var stick_point: Marker3D
@export var wall_check_ray: RayCast3D
@export var animation_tree: AnimationTree
@export var state_label: Label3D
@export var player_collision: CollisionShape3D
@export var alt_cam_pos: Marker3D
@export var default_cam_pos: Marker3D
@export var ray_casts: Node3D
@export var hook_controller: Node
@export var fps_hud: Label
@export var target: Marker3D
@export var sprint_sound_area: Area3D
@export var pause_menu: Control
@export var game_over_menu: Control
@export var results_menu: Control
@export var ui_timer: Control

@onready var playback  = animation_tree["parameters/playback"]
@onready var visuals = $visuals
@onready var camera_mount = $camera_mount
@onready var camera_3d = $camera_mount/SpringArm3D/Camera3D
@onready var spring_arm_3d = $camera_mount/SpringArm3D
@onready var state_machine = $state_machine
@onready var remote_transform_3d = $RemoteTransform3D
@onready var first_person_camera_3d = $FisrtPersonCamera/Camera3D
@onready var alert_text = $HUD/alert_text

#Grpple Hook
@export var hook_raycast: RayCast3D
@export var crosshair: TextureRect

var cam_switched: bool = false
var ADS_LERP: float = 20
var is_crouching: bool = false
var idle_animations: Array = ["idle 1","idle 3","idle 2"]
var left_right_lock: bool = false
var on_ledge: bool = false
var spotted : bool = false
var in_vehicle

const HOOK_AVAILIBLE_TEXTURE = preload("res://addons/grappling_hook_3d/example/hook_availible.png")
const HOOK_NOT_AVAILIBLE_TEXTURE = preload("res://addons/grappling_hook_3d/example/hook_not_availible.png")



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
			#if !in_vehicle:
			remote_transform_3d.rotate_y(deg_to_rad(event.relative.x * sens_horizontal))

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	ray_casts.global_basis = visuals.global_basis
	fps_hud.text = "FPS: %s" % [Engine.get_frames_per_second()]
	if !left_right_lock:
		remote_transform_3d.update_rotation = true
	else:
			remote_transform_3d.update_rotation = false
		
	if in_vehicle:
		remote_transform_3d.rotation.y = 0
	# UI
	if hook_controller.allowed_states.has(state_machine.current_state) and hook_raycast.is_colliding():
		crosshair.texture = HOOK_AVAILIBLE_TEXTURE
	else:
		crosshair.texture = HOOK_NOT_AVAILIBLE_TEXTURE
	
	#Prevents Sprint Sound Detection Area from staying monitorable
	if playback.get_current_node() != "sprint" and playback.get_current_node() != "running":
		sprint_sound_area.monitorable = false
		
	if position.y < -50:
		GlobalVariables.is_game_over = true

	if GlobalVariables.vent_entered:
		first_person_camera_3d.current = true
		visuals.visible = false
	else:
		first_person_camera_3d.current = false
		visuals.visible = true
	
	if get_tree().paused:
		crosshair.visible = false
	else:
		crosshair.visible = true


	#if on_ledge:
		#var obj = ledge_raycast_1.get_collider()
		#if obj is AnimatableBody3D:
			#print("Ledge ",ledge_raycast_1.get_collision_point())
			#print("Player ",position)
			#print("Holder ",stick_point_holder.global_transform.origin)
			#print("X ",stick_point.global_transform.origin.x)
			#print("Z ",stick_point.global_transform.origin.z)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	zoom(delta)
	cam_switch(delta)
	show_game_menus()
	gamepad_camera_movenemt()

func movement(speed, delta):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var movement = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if movement:
		remote_transform_3d.rotation.y = lerp_angle(remote_transform_3d.rotation.y, atan2(-input_dir.x, -input_dir.y), 15 * delta)

	velocity = velocity.move_toward(movement * speed, delta * acceleration)
	
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta
	
	
	move_and_slide()

func move_left_right(raycast: Node3D ,speed, delta):
	#Enables movement of character to the left or right of the object its facing
	move_and_slide()
	var rot = -(atan2(raycast.get_collision_normal().z, raycast.get_collision_normal().x) - PI/2)
	var h_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	velocity = velocity.move_toward(Vector3(h_input,0,0).rotated(Vector3.UP,rot).normalized() * speed , delta * acceleration)

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
	is_crouching = true
	var t := create_tween()
	t.tween_property(player_collision,"position:y",0.575,0)
	t.tween_property(player_collision,"shape:height",1.5,0)
	t.tween_property(cover_shapecast,"position:y",1.6,0)

func stand_collision():
	is_crouching = false
	var t := create_tween()
	t.tween_property(player_collision,"position:y",0.84,0)
	t.tween_property(player_collision,"shape:height",2.191,0)
	#t.tween_property(cover_shapecast,"position:y",1.901,0)
	t.tween_property(cover_shapecast,"position:y",2.285,0)

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

func pull_player_toward_obj(raycast: Node3D):
	if!cover_shapecast.is_colliding():
		var obj = raycast.get_collision_point()
		velocity = Vector3((position.x - obj.x) * -1, 0, (position.z - obj.z) * -1)
		move_and_slide()
		
	else:
		velocity = Vector3.ZERO

#Functions called in Sprint Animation Tracks
func foot_step_sound_start():
	sprint_sound_area.monitorable = true

func foot_step_sound_stop():
	sprint_sound_area.monitorable = false
	
func gamepad_camera_movenemt():
	var axis_vector = Vector2.ZERO
	axis_vector.x = Input.get_action_strength("gamepad_look_right") - Input.get_action_strength("gamepad_look_left")
	axis_vector.y = Input.get_action_strength("gamepad_look_down") - Input.get_action_strength("gamepad_look_up") 
	#var axis_vector = Input.get_vector("gamepad_look_left","gamepad_look_right","gamepad_look_up","gamepad_look_down")
	if (axis_vector.length()):
		camera_mount.rotation.x = clamp(camera_mount.rotation.x, deg_to_rad(-89), deg_to_rad(89))
		camera_mount.rotate_x(deg_to_rad(-axis_vector.y * joy_stick_sens_vertical))
		rotate_y(deg_to_rad(-axis_vector.x * joy_stick_sens_horizontal))
		remote_transform_3d.rotate_y(deg_to_rad(axis_vector.x * joy_stick_sens_horizontal))

func show_game_menus():
	if GlobalVariables.is_game_over:
		game_over_menu.show_screen()
		crosshair.visible = false
		
	if GlobalVariables.goal_reached:
		results_menu.show_screen()
		crosshair.visible = false
		
	if spotted:
		alert_text.visible = true
	else:
		alert_text.visible = false
