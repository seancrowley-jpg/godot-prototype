extends CharacterBody3D
@onready var physical_bone_simulator_3d = $visuals/AnimationLibrary_Godot_Standard/Skeleton3D/PhysicalBoneSimulator3D
@onready var collision_shape_3d = $CollisionShape3D
@onready var animation_player = $visuals/AnimationLibrary_Godot_Standard/AnimationPlayer
@onready var skeleton_3d = $visuals/AnimationLibrary_Godot_Standard/Skeleton3D

var overlapping: bool = false

#func _ready():
	#physical_bone_simulator_3d.physical_bones_start_simulation()
	
func _physics_process(delta):
	# Add the gravity
	if not is_on_floor() and  not physical_bone_simulator_3d.is_simulating_physics():
		velocity.y -= .2 * delta
	if overlapping:
		collision_shape_3d.disabled = true
		physical_bone_simulator_3d.physical_bones_start_simulation()

	move_and_slide()


func _on_area_3d_body_entered(body):
	if body.name == "Player" or body.is_in_group("Ball"):
		overlapping = true


func _on_area_3d_body_exited(body):
	if body.name == "Player" or body.is_in_group("Ball"):
		overlapping = false
