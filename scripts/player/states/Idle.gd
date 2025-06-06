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
var crouch_state: State
@export
var cover_state: State
@export
var grapple_state: State
@export
var in_vehicle_state: State

var idling: bool

func enter() -> void:
	super()
	parent.velocity = Vector3.ZERO
	parent.stand_collision()

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("crouch"):
			return crouch_state
	elif event.is_action_pressed("jump") and parent.is_on_floor():
			return jump_state
	elif Input.get_vector("left", "right", "forward", "back") && !Input.is_action_pressed("sprint"):
		return run_state
	elif Input.get_vector("left", "right", "forward", "back") && Input.is_action_pressed("sprint"):
		return sprint_state
	elif event.is_action_pressed("cover"):
		if parent.cover_raycast_middle.is_colliding() or parent.crouch_cover_raycast_middle.is_colliding():
			return cover_state
	elif event.is_action_pressed("Hook") and parent.hook_raycast.is_colliding():
			return grapple_state
	return null

func process_physics(delta: float) -> State:
	parent.move_and_slide()
	if !parent.is_on_floor():
		return fall_state
	if idling:
		parent.playback.travel(parent.idle_animations.pick_random())
	if parent.in_vehicle:
		return in_vehicle_state
	return null

func exit() -> void:
	super()
	idling = false
	parent.playback.next()

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "idle 2":
		idling = true
