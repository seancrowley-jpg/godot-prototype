extends State

@export
var fall_state: State
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
	parent.velocity.y += parent.jump_force
	parent.stand_collision()


func process_physics(delta: float) -> State:
	if parent.velocity.y < 0:
		return fall_state

	parent.movement(5,delta)
	
	if parent.ledge_raycast_1.is_colliding() and !parent.ledge_raycast_2.is_colliding():
		return ledge_idle_state
	
	if parent.is_on_floor():
		if parent.velocity != Vector3.ZERO && !Input.is_action_pressed("sprint"):
			return run_state
		else:
			return sprint_state
	
	return null
