extends CharacterBody3D


@onready var light = $Light
var rotation_speed = .2

func _physics_process(delta) -> void:
	rotate_spotlight(delta)
	
func rotate_spotlight(delta):
	light.rotation.y += rotation_speed * delta

	if light.rotation_degrees.y > 75:
		rotation_speed = -rotation_speed
	elif light.rotation_degrees.y < -75:
		rotation_speed = rotation_speed * -1
