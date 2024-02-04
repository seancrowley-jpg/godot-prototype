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

func process_input(event: InputEvent) -> State:
	
	if Input.is_action_just_pressed("crouch"):
		return idle_state
	elif Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	elif Input.get_vector("left", "right", "forward", "back") && !Input.is_action_pressed("run"):
		return crouch_walk_state
	elif Input.get_vector("left", "right", "forward", "back") && Input.is_action_pressed("run"):
		return sprint_state
	return null

func process_physics(delta: float) -> State:
	if not parent.is_on_floor():
		parent.velocity.y -= gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
