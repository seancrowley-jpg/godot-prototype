class_name Enemy
extends CharacterBody3D

@onready var state_machine = $state_machine
@onready var navigation_agent_3d = $NavigationAgent3D
@export var animation_tree = Node3D
@export var state_label = Node3D
@onready var detection_area = $Detection
@onready var detection_ray_cast = $DetectionRayCast

@onready var playback  = animation_tree["parameters/playback"]

var SPEED = 5
var alert = false


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
				var player_position = overlap.global_transform.origin
				detection_ray_cast.look_at(player_position, Vector3.UP)
				detection_ray_cast.force_raycast_update()
				
				if detection_ray_cast.is_colliding():
					var collider = detection_ray_cast.get_collider()
					
					if collider.name == "Player":
						detection_ray_cast.debug_shape_custom_color = Color(174,0,0)
						print("SEEN")
						alert = true
					else:
						detection_ray_cast.debug_shape_custom_color = Color(0,255,0)
						print("NOT SEEN")
						alert = false
