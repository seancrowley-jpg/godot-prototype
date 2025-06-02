extends State

@export
var idle_state: State
@export
var run_state: State
@export
var sprint_state: State
@export
var ledge_idle_state: State
@export
var grapple_state: State
@export
var in_vehicle_state: State

func enter() -> void:
	super()
	parent.ledge_raycast_1.set_collision_mask_value(2,true)
	parent.ledge_raycast_2.set_collision_mask_value(2,true)

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("Hook") and parent.hook_raycast.is_colliding():
			return grapple_state
	return

func process_physics(delta: float) -> State:
	parent.movement(5, delta)
	if !parent.on_ledge:
		parent.ledge_raycast_1.force_raycast_update()
		parent.ledge_raycast_2.force_raycast_update()
		
	if parent.ledge_raycast_1.is_colliding() and !parent.ledge_raycast_2.is_colliding():
		return ledge_idle_state
	
	if parent.is_on_floor():
		if parent.velocity != Vector3.ZERO && !Input.is_action_pressed("sprint"):
			return run_state
		elif parent.velocity != Vector3.ZERO && Input.is_action_pressed("sprint"):
			return sprint_state
		return idle_state
		
	if parent.in_vehicle:
		return in_vehicle_state
	return null
	
func exit() -> void:
	super()
	parent.ledge_raycast_1.set_collision_mask_value(2,false)
	parent.ledge_raycast_2.set_collision_mask_value(2,false)
