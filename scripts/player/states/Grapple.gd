extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var ledge_idle_state: State
@export
var jump_state: State

func enter() -> void:
	super()
	parent.stand_collision()

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("Hook"):
			return fall_state
	elif Input.is_action_pressed("jump"):
			return jump_state
	return

func process_physics(delta: float) -> State:
	parent.movement(0,delta)
	if !parent.on_ledge:
		parent.ledge_raycast_1.force_raycast_update()
		parent.ledge_raycast_2.force_raycast_update()
		
	if parent.ledge_raycast_1.is_colliding() and !parent.ledge_raycast_2.is_colliding():
		return ledge_idle_state
	if parent.velocity == Vector3.ZERO:
		return fall_state
		
	return null
	
func exit() -> void:
	pass
	
