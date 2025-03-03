extends Control

@onready var restart_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/RestartButton
@onready var main_menu_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/MainMenuButton

func _ready() -> void:
	restart_button.pressed.connect(get_tree().reload_current_scene)
	main_menu_button.pressed.connect(get_tree().quit)
