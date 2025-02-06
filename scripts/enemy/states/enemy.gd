class_name Enemy
extends CharacterBody3D

@export_group("Nodes")
@export var state_machine : Node
@export var navigation_agent_3d : NavigationAgent3D
@export var animation_tree : AnimationTree
@export var state_label : Label3D
@export var detection_area : Area3D
@export var detection_ray_cast : RayCast3D
@export var vision_timer : Timer
@export var alert_timer : Timer
@export var patrol_timer : Timer

@onready var randPos : Vector3
@onready var playback  = animation_tree["parameters/playback"]

@export_group("Enemy Stats")
@export var SPEED : float = 5
@export var WALK_SPEED: float = 3

@export_group("Enemy Patrol Range")
@export var randXPosRange : Array = [-35 ,30]
@export var randZPosRange : Array = [-48 ,20]

@export_group("Booleans")
@export var alert : bool = false
@export var alert_countdown: bool
@export var go_patrol: bool = false


func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)

func _physics_process(delta) -> void:
	state_machine.process_physics(delta)
	move_and_slide()
	

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
	

func _on_vision_timer_timeout():
	var overlaps = detection_area.get_overlapping_bodies()
	if overlaps.size() > 0:
		for overlap in overlaps:
			if overlap.name == "Player":
				var player_position = overlap.position
				detection_ray_cast.look_at(player_position, Vector3.UP)
				detection_ray_cast.force_raycast_update()
				var collider = detection_ray_cast.get_collider()
				if detection_ray_cast.is_colliding():
					if collider.name == "Player":
						detection_ray_cast.debug_shape_custom_color = Color(174,0,0)
						alert = true
					else:
						detection_ray_cast.debug_shape_custom_color = Color(0,0,0)
						alert_timer.start()


func look_at_player(weight,target):
	var xform := transform
	xform = xform.looking_at(target,Vector3.UP)
	transform = transform.interpolate_with(xform,weight)
	
func move_toward_target_location():
	var destination  = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	look_at_player(0.2, direction + destination)
	if go_patrol:
		velocity  = direction * WALK_SPEED
	else:
		velocity  = direction * SPEED

func _on_alert_timer_timeout():
	alert = false

func _on_detection_body_exited(body):
	if body is Player:
		alert_timer.start()


func _on_patrol_timer_timeout():
	randPos = Vector3(randf_range(randXPosRange[0],randXPosRange[1]), position.y, randf_range(randZPosRange[0],randZPosRange[1]))
	go_patrol = true
