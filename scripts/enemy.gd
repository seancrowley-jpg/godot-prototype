extends CharacterBody3D

@onready var navigation_agent_3d = $NavigationAgent3D
var SPEED = 5
var alert = false


func _physics_process(delta):
	var destination  = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
		
	velocity  = direction * SPEED
	move_and_slide()

func update_target_location(target_location):
	navigation_agent_3d.target_position = target_location

func _on_navigation_agent_3d_target_reached():
	print("HIT")
