extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var run_state: State


func enter() -> void:
	super()
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("cover"):
		return idle_state
	elif Input.get_vector("left", "right", "forward", "back") && !Input.is_action_pressed("sprint"):
		return run_state
	
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		return fall_state
	return null
	
