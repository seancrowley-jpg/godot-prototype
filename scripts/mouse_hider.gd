extends Node

func _ready():
	# Connect joypad signals
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	_check_input_device()

func _check_input_device():
	# Check if any joypad is connected
	var joypads = Input.get_connected_joypads()
	if joypads.size() > 0:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_joy_connection_changed(device: int, connected: bool):
	# Recheck input device when joypad connection changes
	_check_input_device()

func _input(event):
	# Show mouse when mouse is moved, hide when joypad is used
	if event is InputEventMouseMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
