extends Control

@onready var next_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/NextButton
@onready var restart_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/RestartButton
@onready var main_menu_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/MainMenuButton

func _ready() -> void:
	next_button.pressed.connect(load_next_level)
	restart_button.pressed.connect(get_tree().reload_current_scene)
	main_menu_button.pressed.connect(get_tree().quit)

func load_next_level():
	pass
