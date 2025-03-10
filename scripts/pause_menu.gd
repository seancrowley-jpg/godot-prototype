extends Control

@onready var resume_button = $PanelContainer/VBoxContainer/Resume
@onready var restart_button = $PanelContainer/VBoxContainer/Restart
@onready var quit_button = $PanelContainer/VBoxContainer/Quit

func _ready() -> void:
	resume_button.pressed.connect(resume)
	restart_button.pressed.connect(get_tree().reload_current_scene)
	quit_button.pressed.connect(get_tree().quit)

func resume():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	
func pause():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and !get_tree().paused:
		pause()
	elif event.is_action_pressed("ui_cancel") and get_tree().paused:
		resume()


func _on_restart_pressed():
	resume()
	GlobalVariables.level_alerts = 0
