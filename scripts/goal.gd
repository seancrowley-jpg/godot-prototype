extends CSGCombiner3D
var goal_reached : bool

#When player reaches Goal
func _on_area_3d_body_entered(body):
	if body is Player:
		print("Goal Reached")
		goal_reached = true
