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

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	
	if Input.is_action_pressed("crouch"):
		return run_state
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	if Input.get_vector("left", "right", "forward", "back") && Input.is_action_pressed("run"):
		return sprint_state
	return null

func process_physics(delta: float) -> State:
	parent.movement(1)
	if parent.velocity == Vector3.ZERO:
		return crouch_idle_state
	
	if not parent.is_on_floor():
		parent.velocity.y -= gravity * delta
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		return fall_state
	return null
