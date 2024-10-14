extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var run_state: State
@export
var cover_move: State


func enter() -> void:
	super()
	parent.left_right_lock = true

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("cover"):
		return idle_state
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") && parent.cover_raycast_middle.is_colliding():
		return cover_move
	elif Input.is_action_just_pressed("back"):
		return run_state
	
	return null

func process_physics(delta: float) -> State:
	
	#pulls player towards object they are taking cover against
	if(parent.cover_raycast_middle.is_colliding() and !parent.cover_shapecast.is_colliding()):
		var obj = parent.cover_raycast_middle.get_collision_point()
		var direction = parent.global_position.direction_to(obj)
		parent.velocity = Vector3((parent.position.x - obj.x) * -1, 0, (parent.position.z - obj.z) * -1)
	else:
		parent.velocity = Vector3.ZERO
		
	if !parent.is_on_floor():
		return fall_state
		
	#var rot = -(atan2(parent.cover_raycast_middle.get_collision_normal().z, parent.cover_raycast_middle.get_collision_normal().x) - PI/2)
	#parent.visuals.rotation.y = lerp_angle(parent.rotation.y, rot, 1)
	parent.move_and_slide()
	
	return null
	
func process_frame(delta: float) -> State:
	var rot = -(atan2(parent.cover_raycast_middle.get_collision_normal().z, parent.cover_raycast_middle.get_collision_normal().x) - PI/2)
	parent.visuals.rotation.y = lerp_angle(parent.rotation.y, rot, 1)
	return null
	
func exit() -> void:
	super()
	parent.left_right_lock = false
