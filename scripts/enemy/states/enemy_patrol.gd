extends State

@export
var alert_state: State

@export
var idle_state: State

func process_physics(delta: float) -> State:
	if parent.alert:
		return alert_state
	if parent.use_random_patrol_path:
		parent.navigation_agent_3d.target_position = parent.randPos
	else:
		parent.navigation_agent_3d.target_position = parent.enemeyDestinations[parent.currentDestination]
	if parent.navigation_agent_3d.is_navigation_finished():
		return idle_state
	else:
		parent.move_toward_target_location(delta)
	return null


func exit() -> void:
	parent.navigation_agent_3d.target_position = Vector3.ZERO
	parent.velocity = Vector3.ZERO
