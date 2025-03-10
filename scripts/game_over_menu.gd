extends Control

@onready var restart_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/RestartButton
@onready var main_menu_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/MainMenuButton

func _ready() -> void:
	restart_button.pressed.connect(get_tree().reload_current_scene)
	main_menu_button.pressed.connect(get_tree().quit)

func restart():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	GlobalVariables.level_alerts = 0
	
func show_screen():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true

func _on_restart_pressed():
	restart()
