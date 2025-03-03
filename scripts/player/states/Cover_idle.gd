extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var run_state: State
@export
var cover_move_state: State
@export
var crouch_walk_state: State
@export
var crouch_idle_state: State


func enter() -> void:
	super()
	parent.left_right_lock = true
	if parent.is_crouching:
		parent.playback.travel("crouch cover idle")
	else:
		parent.playback.travel("cover idle")
	parent.set_collision_layer_value(2,true)
	parent.set_collision_mask_value(2,true)

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("cover"):
		if parent.is_crouching:
			return crouch_idle_state
		else:
			return idle_state
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right"):
		return cover_move_state
	elif Input.is_action_just_pressed("back"):
		if parent.is_crouching:
			return crouch_walk_state
		else:
			run_state
	elif Input.is_action_just_pressed("crouch"):
		if parent.is_crouching:
			parent.playback.travel("cover idle")
			parent.stand_collision()
		else:
			parent.playback.travel("crouch cover idle")
			parent.crouch_collision()
	
	return null

func process_physics(delta: float) -> State:
	if parent.crouch_cover_raycast_middle.is_colliding() and !parent.cover_raycast_middle.is_colliding():
		parent.playback.travel("crouch cover idle")
		parent.crouch_collision()
		parent.pull_player_toward_obj(parent.crouch_cover_raycast_middle)
	else:
		parent.pull_player_toward_obj(parent.cover_raycast_middle)
		
	if !parent.is_on_floor():
		return fall_state
		
	parent.move_and_slide()
	
	return null
	
func process_frame(delta: float) -> State:
	if parent.crouch_cover_raycast_middle.is_colliding():
		parent.rotate_player_visuals(parent.crouch_cover_raycast_middle)
	else:
		parent.rotate_player_visuals(parent.cover_raycast_middle)
	return null
	
func exit() -> void:
	super()
	parent.left_right_lock = false
	parent.set_collision_layer_value(2,false)
	parent.set_collision_mask_value(2,false)
