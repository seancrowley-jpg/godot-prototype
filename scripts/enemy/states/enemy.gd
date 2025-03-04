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
@export var sprint_sound_area: Area3D

@onready var randPos : Vector3
@onready var playback  = animation_tree["parameters/playback"]

@export_group("Enemy Stats")
@export var SPEED : float = 5
@export var WALK_SPEED: float = 3
@export var fall_acceleration: float = 50
@export var acceleration: float = 30.0
@export var alert_timer_count: float = 2.0
@export var patrol_idle_timer_count: float = 2.0

@export_group("Enemy Patrol Range")
@export var randXPosRange : Array = [0,0]
@export var randZPosRange : Array = [0,0]

@export_group("Enemy Patrol Destinations")
@export var enemeyDestinations : Array[Vector3] = [Vector3.ZERO]
@export var currentDestination: int = 0

@export_group("Booleans")
@export var alert : bool = false
@export var alert_countdown: bool
@export var enemey_can_patrol: bool = true
@export var go_patrol: bool = false
@export var use_random_patrol_path: bool = true

func _ready() -> void:
	# Initialize the state machine, passing a reference of the player to the states,
	# that way they can move and react accordingly
	state_machine.init(self)
	animation_tree.active = true

func _physics_process(delta) -> void:
	state_machine.process_physics(delta)
	rotation.x = 0  #Stop enemies from bobing up and down when moving
	
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta
	
	if GlobalVariables.spotlight_spotted_player and alert_timer.is_stopped():
		alert = true
		alert_timer.start()
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
						alert_timer.start(alert_timer_count)

#Sends player position to nav agent / Called in World script
func update_target_location(target_location):
	if alert:
		navigation_agent_3d.target_position = target_location

func look_at_player(weight,target):
	var xform := transform
	xform = xform.looking_at(target,Vector3.UP)
	transform = transform.interpolate_with(xform,weight)
	
func move_toward_target_location(delta):
	var destination  = navigation_agent_3d.get_next_path_position()
	var local_destination = destination - global_position
	var direction = local_destination.normalized()
	look_at_player(0.2, direction + destination)
	if go_patrol:
		velocity  = velocity.move_toward(direction* WALK_SPEED, acceleration * delta)
	else:
		velocity  = velocity.move_toward(direction* SPEED, acceleration * delta)

func _on_alert_timer_timeout():
	alert = false
	alert_countdown = false

func _on_detection_body_exited(body):
	if body is Player:
		alert_timer.start(alert_timer_count)

func _on_patrol_timer_timeout():
	if use_random_patrol_path:
		randPos = Vector3(randf_range(randXPosRange[0],randXPosRange[1]), position.y, randf_range(randZPosRange[0],randZPosRange[1]))
		
	if enemeyDestinations:
		if currentDestination < enemeyDestinations.size() -1:
			currentDestination += 1
		else:
			currentDestination = 0
	if enemey_can_patrol:
		go_patrol = true

func _on_sprint_sound_area_area_entered(area):
	if area.name == "SprintSoundArea": 
		alert = true
