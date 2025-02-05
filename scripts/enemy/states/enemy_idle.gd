extends State

@export
var alert_state: State

@export
var patrol_state: State

func enter() -> void:
	parent.go_patrol = false
	parent.patrol_timer.start()
	#parent.playback.start("idle")


func process_physics(delta: float) -> State:
	if parent.alert:
		return alert_state
		
	if parent.go_patrol:
		return patrol_state
		
	return null
	
