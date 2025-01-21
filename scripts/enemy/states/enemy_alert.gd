extends State
@export
var idle_state: State

func process_physics(delta: float) -> State:
	var destination  = parent.navigation_agent_3d.get_next_path_position()
	var local_destination = destination - parent.global_position
	var direction = local_destination.normalized()
		
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
