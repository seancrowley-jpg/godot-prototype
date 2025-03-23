extends State

@export
var fall_state: State
@export
var jump_state: State
@export
var run_state: State
@export
var sprint_state: State
@export
var idle_state: State
@export
var crouch_walk_state: State
@export
var cover_idle_state: State

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO
	parent.crouch_collision()
	

func process_input(event: InputEvent) -> State:
	
	if event.is_action_pressed("crouch") and not parent.crouch_shapecast.is_colliding():
		return idle_state
	elif event.is_action_pressed('jump') and parent.is_on_floor() and not parent.crouch_shapecast.is_colliding():
		return jump_state
	elif Input.get_vector("left", "right", "forward", "back") && not Input.is_action_pressed("sprint"):
		return crouch_walk_state
	elif Input.get_vector("left", "right", "forward", "back") && Input.is_action_pressed("sprint") and not parent.crouch_shapecast.is_colliding():
		return sprint_state
	elif event.is_action_pressed("cover") and parent.crouch_cover_raycast_middle.is_colliding() :
		return cover_idle_state
	else:
		return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	return null
	
func exit() -> void:
	super()
	parent.stand_collision()
