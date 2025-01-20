extends State
@export
var alert_state: State

func process_physics(delta: float) -> State:
	if parent.alert:
		return alert_state
	return null
	
