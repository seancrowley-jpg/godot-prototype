extends State


func process_physics(delta: float) -> State:
	var destination  = parent.navigation_agent_3d.get_next_path_position()
	var local_destination = destination - parent.global_position
	var direction = local_destination.normalized()
		
	parent.velocity  = direction * parent.SPEED
	return null
