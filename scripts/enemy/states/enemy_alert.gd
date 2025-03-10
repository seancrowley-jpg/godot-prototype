extends State
@export
var idle_state: State

func enter() -> void:
	super()
	parent.go_patrol = false
	GlobalVariables.level_alerts += 1

func process_physics(delta: float) -> State:
	parent.move_toward_target_location(delta)
	
	if parent.navigation_agent_3d.is_target_reached():
		return idle_state
		
	if !parent.navigation_agent_3d.is_target_reachable():
		return idle_state
	
	return null

func _on_navigation_agent_3d_target_reached():
	pass
	#print("HIT")
	
func exit() -> void:
	parent.velocity = Vector3.ZERO
