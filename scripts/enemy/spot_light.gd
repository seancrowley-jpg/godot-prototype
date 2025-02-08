extends CharacterBody3D

@export var detection_area : Area3D
@export var detection_ray_cast : RayCast3D


@onready var light = $Light
@onready var marker_3d = $Marker3D
@onready var player = get_tree().get_first_node_in_group("Player")

var rotation_speed = .5
var spotted: bool

func _physics_process(delta) -> void:
	rotate_spotlight(delta)

func rotate_spotlight(delta):
	light.rotation.y += rotation_speed * delta
	
	if spotted:
		light.look_at(player.target.global_position, Vector3.UP)
	else:
		light.rotation.x = -0.208742


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
						spotted = true
					else:
						detection_ray_cast.debug_shape_custom_color = Color(0,0,0)
						GlobalVariables.spotlight_spotted_player = false
						spotted = false


#When players leaves detection area / Light
func _on_detection_body_exited(body):
	if body is Player:
		GlobalVariables.spotlight_spotted_player = false
		spotted = false
		
func _on_detection_body_entered(body):
	pass
