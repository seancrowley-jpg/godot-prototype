extends State

@export
var idle_state: State
@export
var fall_state: State
@export
var run_state: State
@export
var cover_move: State


func enter() -> void:
	super()
	parent.left_right_lock = true

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("cover"):
		return idle_state
	elif Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") && parent.cover_raycast_middle.is_colliding():
		return cover_move
	elif Input.is_action_just_pressed("back"):
		return run_state
	
	return null

func process_physics(delta: float) -> State:
	parent.pull_player_toward_obj(parent.cover_raycast_middle)
		
	if !parent.is_on_floor():
		return fall_state
		
	parent.move_and_slide()
	
	return null
	
func process_frame(delta: float) -> State:
	parent.rotate_player_visuals(parent.cover_raycast_middle)
	return null
	
func exit() -> void:
	super()
	parent.left_right_lock = false
