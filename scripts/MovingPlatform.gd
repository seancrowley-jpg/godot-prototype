extends PathFollow3D

@export var speed: float

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (progress_ratio < 1):
		progress_ratio += speed * delta
