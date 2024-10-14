extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var run_state: State
@export
var sprint_state: State
@export
var idle_state: State
@export
var crouch_walk_state: State

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO
	parent.crouch_collision()
	

func process_input(event: InputEvent) -> State:
	
	if Input.is_action_just_pressed("crouch") and !parent.crouch_shapecast.is_colliding():
		return idle_state
	elif Input.is_action_just_pressed('jump') and parent.is_on_floor() and !parent.crouch_shapecast.is_colliding():
		return jump_state
	elif Input.get_vector("left", "right", "forward", "back") && !Input.is_action_pressed("sprint"):
		return crouch_walk_state
	elif Input.get_vector("left", "right", "forward", "back") && Input.is_action_pressed("sprint") and !parent.crouch_shapecast.is_colliding():
		return sprint_state
	else:
		return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	var rot = -(atan2(parent.wall_check_ray.get_collision_normal().z, parent.wall_check_ray.get_collision_normal().x) - PI/2)
	parent.visuals.rotation.y = lerp_angle(parent.rotation.y, rot, 1)
	if !parent.is_on_floor():
		return fall_state
	return null
	
func exit() -> void:
	super()
	parent.stand_collision()
