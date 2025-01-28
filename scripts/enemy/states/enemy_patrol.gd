extends State

@export
var alert_state: State

@export
var idle_state: State

func process_physics(delta: float) -> State:
	if parent.alert:
		return alert_state
	
	return null
