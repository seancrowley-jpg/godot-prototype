extends State

@export
var idle_state: State
@export
var run_state: State

func enter() -> void:
	super()
	#parent.visible = false
	#parent.left_right_lock = true

func process_physics(delta: float) -> State:
	#parent.movement(0,delta)
	
	if !parent.in_vehicle:
		return idle_state
	return null
	
func exit() -> void:
	parent.visible = true
	#parent.left_right_lock = false
