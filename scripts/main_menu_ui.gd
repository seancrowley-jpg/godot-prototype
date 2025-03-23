extends Control

@onready var level_select_button = $PanelContainer/VBoxContainer/LevelSelectButton
@onready var exit_button = $PanelContainer/VBoxContainer/ExitButton
@onready var level_select_menu = $"../level_select_menu"

func _ready() -> void:
	level_select_button.grab_focus()
	exit_button.pressed.connect(get_tree().quit)

func _on_level_select_button_pressed():
	visible = false
	level_select_menu.visible = true
