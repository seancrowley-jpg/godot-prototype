extends Area3D


func _on_body_entered(body):
	if body.name == "Player":
		GlobalVariables.vent_entered = true


func _on_body_exited(body):
	if body.name == "Player":
		GlobalVariables.vent_entered = false
