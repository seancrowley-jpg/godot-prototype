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
var crouch_state: State



func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("crouch"):
			return crouch_state
	elif event.is_action_pressed("jump") and parent.is_on_floor():
			return jump_state
	elif Input.get_vector("left", "right", "forward", "back") && !event.is_action_pressed("sprint"):
		return run_state
	elif Input.get_vector("left", "right", "forward", "back") && !event.is_action_pressed("sprint"):
		return sprint_state
	return null

func process_physics(delta: float) -> State:
	if not parent.is_on_floor():
		parent.velocity.y -= gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
