extends State

@export
var sprint_state: State
@export
var fall_state: State
@export
var run_state: State
@export
var idle_state: State
@export
var crouch_idle_state: State

@export
var roll_speed: float = 12

var anim_fin = false

func enter() -> void:
	super()
	parent.crouch_collision()
	
func process_physics(delta: float) -> State:
	parent.movement(roll_speed)
	
	if !parent.is_on_floor():
		return fall_state
		
	if anim_fin && !parent.crouch_shapecast.is_colliding():
		if !Input.is_action_pressed("run") && parent.velocity:
			return run_state
		elif Input.is_action_pressed("run") && parent.velocity:
			return sprint_state
		elif !parent.velocity:
			return idle_state
	elif anim_fin && parent.crouch_shapecast.is_colliding():
		return crouch_idle_state
		
	
	return null

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == "sprint to roll":
		anim_fin = true
		
func exit() -> void:
	super()
	anim_fin = false
