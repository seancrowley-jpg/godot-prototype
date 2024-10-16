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
	parent.on_ledge = true
	parent.left_right_lock = true
	if Input.is_action_pressed("left"):
		parent.playback.travel("hang shimmy animations_hang shimmy left")

	if Input.is_action_pressed("right"):
		parent.playback.travel("hang shimmy animations_hang shimmy right")

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("jump"):
		parent.disbable_ledge_raycasts()
		parent.raycast_timer.start()
		return jump_state
	if Input.is_action_just_pressed("crouch"):
		parent.disbable_ledge_raycasts()
		parent.raycast_timer.start()
		return fall_state
	return null

func process_physics(delta: float) -> State:
	parent.move_left_right(parent.ledge_raycast_1)
	if !parent.ledge_raycast_1.is_colliding():
		parent.raycast_timer.start()
		return fall_state
	elif parent.ledge_raycast_1.is_colliding() and parent.ledge_raycast_2.is_colliding():
		parent.disbable_ledge_raycasts()
		parent.raycast_timer.start()
		return fall_state
	
	
	if parent.velocity == Vector3.ZERO:
		return ledge_idle_state
	
	return null

func exit() -> void:
	super()
	parent.left_right_lock = false
