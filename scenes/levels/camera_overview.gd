extends Marker3D
@onready var pivot = $pivot
@export var rotation_speed = .2
@onready var camera_3d = $pivot/Camera3D

func _ready():
	get_tree().paused = true
	GlobalVariables.is_in_overview = true

func _process(delta: float):
	pivot.rotate_y(rotation_speed * delta)
	
func _input(event):
	if Input.is_action_just_pressed("jump"):
		get_tree().paused = false
		GlobalVariables.is_in_overview = false
		queue_free()
