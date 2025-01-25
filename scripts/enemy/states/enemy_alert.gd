extends State
@export
var idle_state: State

func process_physics(delta: float) -> State:
	parent.move_toward_target_location()
	
	if parent.navigation_agent_3d.is_target_reached():
		return idle_state
	
	return null

func update_target_location(target_location):
	parent.navigation_agent_3d.target_position = target_location



func _on_navigation_agent_3d_target_reached():
	pass
	#print("HIT")
	
func look_at_player(weight,target):
	var xform := parent.transform
	xform = xform.looking_at(target,Vector3.UP)
	parent.transform = parent.transform.interpolate_with(xform,weight)
	
func exit() -> void:
	parent.navigation_agent_3d.target_position = Vector3.ZERO
	parent.velocity = Vector3.ZERO
