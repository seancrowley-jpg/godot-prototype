class_name Enemy
extends CharacterBody3D

@onready var state_machine = $state_machine
@onready var navigation_agent_3d = $NavigationAgent3D
@export var animation_tree = Node3D
@export var state_label = Node3D
@onready var detection_area = $Detection
@onready var detection_ray_cast = $DetectionRayCast
@onready var vision_timer = $VisionTimer
@onready var alert_timer = $AlertTimer

@onready var playback  = animation_tree["parameters/playback"]

var SPEED = 5
var alert = false
var alert_countdown: bool


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
	velocity  = direction * SPEED


func _on_alert_timer_timeout():
	#print("count started")
	alert = false
	return

func _on_detection_body_exited(body):
	if body is Player:
		#print("body exited")
		alert_timer.start()
