extends State

@export
var fall_state: State
@export
var jump_state: State

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO
	parent.ledge_raycast_1.enabled = false
	parent.ledge_raycast_2.enabled = false
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("jump"):
		return jump_state
	if Input.is_action_just_pressed("crouch"):
			return fall_state
	return null
	
func process_physics(delta: float) -> State:
	parent.movement(0,0)
	return null
	
func exit() -> void:
	super()
	parent.timer.start()
