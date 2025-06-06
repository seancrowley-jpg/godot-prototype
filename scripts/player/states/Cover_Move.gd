extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var run_state: State
@export
var cover_idle: State
@export
var sprint_state: State
@export
var crouch_walk_state: State
@export
var crouch_idle_state: State


func enter() -> void:
	super()
	if Input.is_action_pressed("left"):
		if parent.is_crouching:
			parent.playback.travel("left crouch sneak")
		else:
			parent.playback.travel("right cover sneak")
	if Input.is_action_pressed("right"):
		if parent.is_crouching:
			parent.playback.travel("right crouch sneak")
		else:
			parent.playback.travel("left cover sneak")
	parent.left_right_lock = true
	parent.set_collision_layer_value(2,true)
	parent.set_collision_mask_value(2,true)


func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("cover"):
		if parent.is_crouching:
			return crouch_idle_state
		else:
			return idle_state
			
	elif Input.get_vector("left", "right", "forward", "back") && event.is_action_pressed("sprint"):
		parent.playback.start("sprint")
		return sprint_state
		
	elif event.is_action_pressed("back"):
		if parent.is_crouching:
			return crouch_walk_state
		else:
			parent.playback.start("running")
			return run_state
			
	elif event.is_action_pressed("crouch"):
		if parent.is_crouching:
			parent.stand_collision()
		else:
			parent.crouch_collision()
			
	elif Input.is_action_pressed("left"):
		if parent.is_crouching:
			parent.playback.travel("left crouch sneak")
		else:
			parent.playback.travel("right cover sneak")
	elif Input.is_action_pressed("right"):
		if parent.is_crouching:
			parent.playback.travel("right crouch sneak")
		else:
			parent.playback.travel("left cover sneak")
	
	return null

func process_physics(delta: float) -> State:
	if parent.crouch_cover_raycast_middle.is_colliding() and !parent.cover_raycast_middle.is_colliding():
		parent.move_left_right(parent.crouch_cover_raycast_middle , parent.cover_move_speed, delta)
	else:
		parent.move_left_right(parent.cover_raycast_middle, parent.cover_move_speed, delta)
	
	if !parent.cover_shapecast.is_colliding():
		if parent.is_crouching:
			return crouch_walk_state
		else:
			parent.playback.start("running")
			return run_state
	
	if !parent.is_on_floor():
		parent.stand_collision()
		return fall_state
		
	if parent.velocity == Vector3.ZERO:
		return cover_idle
		
	return null
	
func exit() -> void:
	super()
	parent.left_right_lock = false
	parent.set_collision_layer_value(2,false)
	parent.set_collision_mask_value(2,false)
