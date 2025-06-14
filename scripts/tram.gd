extends AnimatableBody3D
@export var speed : float = 4.0
@export var player : Player
@export var path3d: PathFollow3D

var overlapping: bool = false
var accelerate = false

func _input(event):
	if overlapping and event.is_action_pressed("interact") and !accelerate:
		accelerate = true
	elif overlapping and event.is_action_pressed("interact") and accelerate:
		accelerate = false

func _physics_process(delta):
	if overlapping:
		player.enter_vehicle_label.visible = true
	else:
		player.enter_vehicle_label.visible = false
		accelerate = false
	
	if accelerate:
		path3d.progress_ratio += 0.0001 * speed
		player.enter_vehicle_label.visible = false


func _on_player_interact_area_3d_body_entered(body):
	if body.name == "Player":
		overlapping = true


func _on_player_interact_area_3d_body_exited(body):
	if body.name == "Player":
		overlapping = false
