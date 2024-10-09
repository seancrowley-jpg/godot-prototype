extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var ledge_idle_state: State

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO
	parent.ledge_raycast_1.enabled = false
	parent.ledge_raycast_2.enabled = false
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("jump"):
		parent.timer.start()
		return jump_state
	if Input.is_action_just_pressed("crouch"):
		parent.timer.start()
		return fall_state
	return null
	
func process_physics(delta: float) -> State:
	parent.move_left_right()
	if !parent.wall_check_ray.is_colliding():
		parent.timer.start()
		return fall_state
	
	if parent.velocity == Vector3.ZERO:
		return ledge_idle_state
	
	return null
	
func exit() -> void:
	super()
