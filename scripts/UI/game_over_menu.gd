extends Control

@onready var restart_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/RestartButton
@onready var main_menu_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/MainMenuButton
@onready var audio_stream_player = $AudioStreamPlayer

func _ready() -> void:
	restart_button.pressed.connect(get_tree().reload_current_scene)

func restart():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	GlobalVariables.level_alerts = 0
	GlobalVariables.is_game_over = false
	
func show_screen():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	restart_button.grab_focus()

func _on_restart_pressed():
	restart()

func _on_main_menu_button_pressed():
	GlobalVariables.is_game_over = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/main_menu.tscn")

#region
## Signals for button sounds and focus
func _on_restart_button_mouse_entered():
	restart_button.grab_focus()
	audio_stream_player.play()


func _on_restart_button_focus_entered():
	audio_stream_player.play()


func _on_main_menu_button_focus_entered():
	audio_stream_player.play()


func _on_main_menu_button_mouse_entered():
	main_menu_button.grab_focus()
	audio_stream_player.play()
#endregion
