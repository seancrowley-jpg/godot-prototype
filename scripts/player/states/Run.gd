extends State

@export
var fall_state: State
@export
var idle_state: State
@export
var jump_state: State
@export
var sprint_state : State
@export
var crouch_walk : State
@export
var cover_state: State
@export
var grapple_state: State

func enter() -> void:
	super()

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if Input.is_action_just_pressed('jump'):
			return jump_state
		elif Input.is_action_just_pressed('sprint'):
			return sprint_state
		elif Input.is_action_just_pressed('crouch'):
			return crouch_walk
		elif Input.is_action_pressed("cover") and parent.cover_raycast_middle.is_colliding():
			return cover_state
		elif Input.is_action_pressed("Hook") and parent.hook_raycast.is_colliding():
			return grapple_state
	return null

func process_physics(delta: float) -> State:
	parent.movement(5, delta)
	if parent.velocity == Vector3.ZERO:
		return idle_state
	
	if !parent.is_on_floor():
		return fall_state
	return null
