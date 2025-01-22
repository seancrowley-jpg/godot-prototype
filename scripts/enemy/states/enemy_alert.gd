extends State
@export
var idle_state: State

func process_physics(delta: float) -> State:
	var destination  = parent.navigation_agent_3d.get_next_path_position()
	var local_destination = destination - parent.global_position
	var direction = local_destination.normalized()
	
	#parent.look_at(direction + destination,Vector3.UP)
	look_at_player(0.2, direction + destination)

	parent.velocity  = direction * parent.SPEED
	return null

func update_target_location(target_location):
	parent.navigation_agent_3d.target_position = target_location

func _on_detection_body_entered(body):
	if body.name == "Player":
		print("Enter")
		parent.alert = true

func _on_navigation_agent_3d_target_reached():
	print("HIT")
	
func look_at_player(weight,target):
	var xform := parent.transform
	xform = xform.looking_at(target,Vector3.UP)
	parent.transform = parent.transform.interpolate_with(xform,weight)
	
