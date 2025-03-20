extends State
@export
var idle_state: State

func enter() -> void:
	super()
	parent.go_patrol = false
	GlobalVariables.level_alerts += 1

func process_physics(delta: float) -> State:
	if parent.navigation_agent_3d.is_navigation_finished():
		return idle_state
	else:
		parent.move_toward_target_location(delta)
	return null

func exit() -> void:
	super()
	parent.velocity = Vector3.ZERO
	parent.alert = false


func _on_catch_player_area_3d_body_entered(body):
	if body.name == "Player" and parent.alert:
		GlobalVariables.is_game_over = true
