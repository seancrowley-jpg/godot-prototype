class_name Enemy
extends CharacterBody3D

@onready var state_machine = $state_machine
@onready var navigation_agent_3d = $NavigationAgent3D
@export var animation_tree = Node3D
@export var state_label = Node3D
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
