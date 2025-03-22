extends CSGCombiner3D

func _ready():
	GlobalVariables.goal_reached = false
#When player reaches Goal
func _on_area_3d_body_entered(body):
	if body is Player:
		GlobalVariables.goal_reached = true
