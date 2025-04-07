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
	parent.left_right_lock = true
	parent.on_ledge = true
	parent.set_collision_layer_value(2,true)
	parent.set_collision_mask_value(2,true)
	parent.ledge_raycast_1.set_collision_mask_value(2,true)
	parent.ledge_raycast_2.set_collision_mask_value(2,true)

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump"):
		parent.disbable_ledge_raycasts()
		parent.raycast_timer.start()
		return jump_state
	elif event.is_action_pressed("crouch"):
		parent.disbable_ledge_raycasts()
		parent.raycast_timer.start()
		return fall_state
	elif Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		return ledge_move
	return null

func process_physics(delta: float) -> State:
	parent.pull_player_toward_obj(parent.ledge_raycast_1)
	
	if parent.ledge_raycast_1.is_colliding() and parent.ledge_raycast_2.is_colliding():
		parent.disbable_ledge_raycasts()
		parent.raycast_timer.start()
		return fall_state
	
	if !parent.ledge_raycast_1.is_colliding():
		parent.raycast_timer.start()
		return fall_state
	
	#parent.move_and_slide()
	
	return null

func process_frame(delta: float) -> State:
	parent.rotate_player_visuals(parent.ledge_raycast_1)
	if !parent.wall_check_ray.is_colliding():
		parent.playback.travel("y-bot free hang_Free hang idle")
	return null

func exit() -> void:
	super()
	parent.left_right_lock = false
	parent.set_collision_layer_value(2,false)
	parent.set_collision_mask_value(2,false)
	parent.ledge_raycast_1.set_collision_mask_value(2,false)
	parent.ledge_raycast_2.set_collision_mask_value(2,false)
