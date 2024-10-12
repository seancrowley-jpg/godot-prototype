extends State

@export
var idle_state: State
@export
var run_state: State
@export
var sprint_state: State
@export
var ledge_idle_state: State

func enter() -> void:
	super()

	
func process_physics(delta: float) -> State:
	parent.movement(5, delta)
	
	if parent.ledge_raycast_1.is_colliding() and !parent.ledge_raycast_2.is_colliding():
		return ledge_idle_state
	
	if parent.is_on_floor():
		if parent.velocity != Vector3.ZERO && !Input.is_action_pressed("sprint"):
			return run_state
		elif parent.velocity != Vector3.ZERO && Input.is_action_pressed("sprint"):
			return sprint_state
		return idle_state
	return null
