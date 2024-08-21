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
var jump_force: float = 10

func enter() -> void:
	super()
	parent.velocity.y = jump_force
	parent.stand_collision()


func process_physics(delta: float) -> State:
	parent.velocity.y -= gravity * delta
	if parent.velocity.y < 0:
		return fall_state

	parent.movement(5)
	
	
	if parent.is_on_floor():
		if parent.velocity != Vector3.ZERO && !Input.is_action_pressed("run"):
			return run_state
		else:
			return sprint_state
		return idle_state
	
	return null
