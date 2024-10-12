extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var ledge_move: State

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO
	parent.ledge_raycast_1.enabled = false
	parent.ledge_raycast_2.enabled = false
	
func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump"):
		parent.timer.start()
		return jump_state
	elif Input.is_action_just_pressed("crouch"):
		parent.timer.start()
		return fall_state
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return ledge_move
	return null
	
func process_physics(delta: float) -> State:
	if!parent.cover_shapecast.is_colliding():
		var obj =parent.cover_raycast_middle.get_collision_point()
		parent.velocity = Vector3((parent.position.x - obj.x) * -1, 0, (parent.position.z - obj.z) * -1)
	else:
		parent.velocity = Vector3.ZERO
		
	parent.move_and_slide()
	
	
	return null
	
func exit() -> void:
	super()
