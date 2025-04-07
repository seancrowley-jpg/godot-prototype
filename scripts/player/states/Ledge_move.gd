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
	parent.set_collision_layer_value(2,true)
	parent.set_collision_mask_value(2,true)
	parent.ledge_raycast_1.set_collision_mask_value(2,true)
	parent.ledge_raycast_2.set_collision_mask_value(2,true)
	if Input.is_action_pressed("left"):
		if !parent.wall_check_ray.is_colliding():
			parent.playback.travel("y-bot free hang_Free hang left")
		else:
			parent.playback.travel("hang shimmy animations_hang shimmy left")

	if Input.is_action_pressed("right"):
		if !parent.wall_check_ray.is_colliding():
			parent.playback.travel("y-bot free hang_Free hang right")
		else:
			parent.playback.travel("hang shimmy animations_hang shimmy right")

func process_input(event: InputEvent) -> State:
	if Input.is_action_pressed("jump"):
		parent.disbable_ledge_raycasts()
		parent.raycast_timer.start()
		return jump_state
	if event.is_action_pressed("crouch"):
		parent.disbable_ledge_raycasts()
		parent.raycast_timer.start()
		return fall_state
	return null

func process_physics(delta: float) -> State:
	parent.move_left_right(parent.ledge_raycast_1, parent.ledge_move_speed, delta)
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

func process_frame(delta: float) -> State:
	parent.rotate_player_visuals(parent.ledge_raycast_1)
	if !parent.wall_check_ray.is_colliding():
		if Input.is_action_pressed("left"):
			parent.playback.travel("y-bot free hang_Free hang left")
		elif Input.is_action_pressed("right"):
			parent.playback.travel("y-bot free hang_Free hang right")
	else:
		if Input.is_action_pressed("left"):
			parent.playback.travel("hang shimmy animations_hang shimmy left")
		elif Input.is_action_pressed("right"):
			parent.playback.travel("hang shimmy animations_hang shimmy right")
	return null

func exit() -> void:
	super()
	parent.left_right_lock = false
	parent.set_collision_layer_value(2,false)
	parent.set_collision_mask_value(2,false)
	parent.ledge_raycast_1.set_collision_mask_value(2,false)
	parent.ledge_raycast_2.set_collision_mask_value(2,false)
