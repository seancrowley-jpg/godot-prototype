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
	

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("cover"):
		return idle_state
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") && !Input.is_action_pressed("sprint"):
		return cover_move
	elif Input.is_action_just_pressed("back"):
		return run_state
	
	return null

func process_physics(delta: float) -> State:
	if !parent.is_on_floor():
		return fall_state
	return null
	
