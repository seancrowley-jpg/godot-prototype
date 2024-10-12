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


func enter() -> void:
	super()
	if Input.is_action_pressed("left"):
		parent.playback.travel("right cover sneak")
	if Input.is_action_pressed("right"):
		parent.playback.travel("left cover sneak")


func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("cover"):
		return idle_state
	elif Input.get_vector("left", "right", "forward", "back") && Input.is_action_pressed("sprint"):
		parent.playback.start("sprint")
		return sprint_state
	elif Input.is_action_just_pressed("back"):
		parent.playback.start("running")
		return run_state
	
	return null

func process_physics(delta: float) -> State:
	if parent.cover_raycast_middle.is_colliding():
		parent.movement(1, delta)
	elif !parent.cover_raycast_left.is_colliding() or !parent.cover_raycast_right.is_colliding():
		parent.playback.start("running")
		return run_state

	if !parent.is_on_floor():
		return fall_state
		
	if parent.velocity == Vector3.ZERO:
		return cover_idle
		
	parent.visuals.rotation.y = 0
	return null
	
func exit() -> void:
	super()
	parent.stand_collision()
