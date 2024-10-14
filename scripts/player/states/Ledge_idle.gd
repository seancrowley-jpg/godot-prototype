extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var ledge_move: State

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO
	parent.ledge_raycast_1.enabled = false
	parent.ledge_raycast_2.enabled = false
	#var rot = -(atan2(parent.wall_check_ray.get_collision_normal().z, parent.wall_check_ray.get_collision_normal().x) - PI/2)
	#parent.visuals.rotation.y = lerp_angle(parent.rotation.y, rot, 1)
	parent.left_right_lock = true
	
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		parent.timer.start()
		return jump_state
	elif Input.is_action_just_pressed("crouch"):
		parent.timer.start()
		return fall_state
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return ledge_move
	return null
	
func process_physics(delta: float) -> State:
	#var rot = -(atan2(parent.wall_check_ray.get_collision_normal().z, parent.wall_check_ray.get_collision_normal().x) - PI/2)
	#parent.visuals.rotation.y = lerp_angle(parent.rotation.y, rot, 1)
	if!parent.cover_shapecast.is_colliding():
		var obj =parent.cover_raycast_middle.get_collision_point()
		parent.velocity = Vector3((parent.position.x - obj.x) * -1, 0, (parent.position.z - obj.z) * -1)
	else:
		parent.velocity = Vector3.ZERO
		
	parent.move_and_slide()
	
	
	return null
	
func process_frame(delta: float) -> State:
	var rot = -(atan2(parent.wall_check_ray.get_collision_normal().z, parent.wall_check_ray.get_collision_normal().x) - PI/2)
	parent.visuals.rotation.y = lerp_angle(parent.rotation.y, rot, 1)
	return null
	
func exit() -> void:
	super()
	parent.left_right_lock = false
