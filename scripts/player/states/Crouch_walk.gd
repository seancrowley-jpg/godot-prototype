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
var crouch_idle_state: State
@export
var cover_idle_state: State

func enter() -> void:
	super()
	parent.crouch_collision()

func process_input(event: InputEvent) -> State:
	
	if Input.is_action_just_pressed("crouch") and !parent.crouch_shapecast.is_colliding():
		return run_state
	elif Input.is_action_just_pressed('jump') and parent.is_on_floor() and !parent.crouch_shapecast.is_colliding():
		return jump_state
	elif Input.get_vector("left", "right", "forward", "back") and Input.is_action_pressed("sprint") and !parent.crouch_shapecast.is_colliding():
		return sprint_state
	elif Input.is_action_just_pressed("cover") and parent.crouch_cover_raycast_middle.is_colliding():
		return cover_idle_state
	return null

func process_physics(delta: float) -> State:
	parent.movement(parent.crouch_move_speed, delta)
	if parent.velocity == Vector3.ZERO:
		return crouch_idle_state
	
	if !parent.is_on_floor():
		return fall_state
		
	return null
	
func exit() -> void:
	super()
	parent.stand_collision()
