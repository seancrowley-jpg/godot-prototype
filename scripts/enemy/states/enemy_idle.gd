extends State

@export
var alert_state: State

@export
var patrol_state: State

func enter() -> void:
	super()
	parent.go_patrol = false
	parent.patrol_timer.start(parent.patrol_idle_timer_count)
	#parent.playback.start("idle")


func process_physics(delta: float) -> State:
	if parent.alert:
		parent.patrol_timer.stop()
		return alert_state
		
	if parent.go_patrol:
		return patrol_state
		
	return null
	
