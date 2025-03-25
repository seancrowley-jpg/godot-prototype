extends Node3D
@onready var lights = $Lights

func _on_area_3d_body_entered(body):
	if body.name == "Player" or body.name.contains("Enemy"):
		lights.visible = true


func _on_area_3d_body_exited(body):
	if body.name == "Player" or body.name.contains("Enemy"):
		lights.visible = false
