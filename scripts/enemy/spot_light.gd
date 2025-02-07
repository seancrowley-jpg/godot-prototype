extends CharacterBody3D


@onready var light = $Light

func _physics_process(delta) -> void:
	
	light.rotation.y += .25 * delta
