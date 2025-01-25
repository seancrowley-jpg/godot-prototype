extends Node3D

@onready var player = $Player
@onready var enemy = $Enemy


func _physics_process(delta):
	if enemy.alert:
		get_tree().call_group("Enemies", "update_target_location", player.global_transform.origin)
