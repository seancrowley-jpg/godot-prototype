extends Control

@onready var level_select_button = $PanelContainer/VBoxContainer/LevelSelectButton
@onready var exit_button = $PanelContainer/VBoxContainer/ExitButton

func _ready() -> void:
	#level_select_button.pressed.connect()
	exit_button.pressed.connect(get_tree().quit)
