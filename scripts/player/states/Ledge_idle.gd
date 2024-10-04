extends State

@export
var fall_state: State
@export
var jump_state: State

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO
	
func process_input(event: InputEvent) -> State:
	return null
	
func process_physics(delta: float) -> State:
	parent.movement(0,0)
	return null
