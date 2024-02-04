extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var run_state: State
@export
var jump_state: State

@export
var sprint_speed: float = 10

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed('jump') and parent.is_on_floor():
		return jump_state
	return null

func process_physics(delta: float) -> State:
	parent.movement(sprint_speed)

	
	if !Input.is_action_pressed("run") && parent.velocity:

		return run_state
		
	if !parent.velocity:
		return idle_state
	

	if !parent.is_on_floor():
		return fall_state
	
	return null
	

