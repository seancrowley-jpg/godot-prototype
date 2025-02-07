extends CharacterBody3D

@export var detection_area : Area3D
@export var detection_ray_cast : RayCast3D

@onready var light = $Light

var rotation_speed = .2

func _physics_process(delta) -> void:
	rotate_spotlight(delta)
	print(GlobalVariables.spotlight_spotted_player)
	
func rotate_spotlight(delta):
	light.rotation.y += rotation_speed * delta

	if light.rotation_degrees.y > 75:
		rotation_speed = -rotation_speed
	elif light.rotation_degrees.y < -75:
		rotation_speed = rotation_speed * -1


func _on_vision_timer_timeout():
	var overlaps = detection_area.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "Player":
				var player_position = overlap.position
				detection_ray_cast.look_at(player_position, Vector3.UP)
				detection_ray_cast.force_raycast_update()
				var collider = detection_ray_cast.get_collider()
				if detection_ray_cast.is_colliding():
					if collider.name == "Player":
						detection_ray_cast.debug_shape_custom_color = Color(174,0,0)
						GlobalVariables.spotlight_spotted_player = true
					else:
						detection_ray_cast.debug_shape_custom_color = Color(0,0,0)
			else:
				GlobalVariables.spotlight_spotted_player = false
