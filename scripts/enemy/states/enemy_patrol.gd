extends State

@export
var alert_state: State

@export
var idle_state: State

func process_physics(delta: float) -> State:
	if parent.alert:
		return alert_state
	parent.navigation_agent_3d.target_position = parent.randPos
	parent.move_toward_target_location()
	if parent.navigation_agent_3d.is_target_reached():
		return idle_state
	return null


func exit() -> void:
	parent.navigation_agent_3d.target_position = Vector3.ZERO
	parent.velocity = Vector3.ZERO
