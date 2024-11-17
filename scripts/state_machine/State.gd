class_name State
extends Node

@export
var animation_name: String

@export
var state_name: String
var previous_state_name: String
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

## Hold a reference to the parent so that it can be controlled by the state
var parent: Player

func enter() -> void:
	parent.playback.travel(animation_name)
	parent.state_label.text = state_name
	print("Entering " + state_name)

func exit() -> void:
	previous_state_name = state_name
	#print("previous: ", previous_state_name)
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
