extends Control

@onready var resume_button = $PanelContainer/VBoxContainer/Resume
@onready var restart_button = $PanelContainer/VBoxContainer/Restart
@onready var quit_button = $PanelContainer/VBoxContainer/Quit
@onready var main_menu = $PanelContainer/VBoxContainer/MainMenu
@onready var audio_stream_player = $AudioStreamPlayer

func _ready() -> void:
	resume_button.pressed.connect(resume)
	restart_button.pressed.connect(get_tree().reload_current_scene)
	quit_button.pressed.connect(get_tree().quit)

func resume():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false
	get_parent().get_child(0).visible = true
	
func pause():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true
	resume_button.grab_focus()
	get_parent().get_child(0).visible = false
	
	
func _unhandled_input(event):
	if not GlobalVariables.is_game_over and not GlobalVariables.goal_reached and not GlobalVariables.is_in_overview:
		if event.is_action_pressed("pause") and not get_tree().paused:
			pause()
		elif event.is_action_pressed("pause") and get_tree().paused:
			resume()

func _on_restart_pressed():
	resume()
	GlobalVariables.level_alerts = 0

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/main_menu.tscn")

#region
## Signals for button sounds and focus
func _on_resume_focus_entered():
	audio_stream_player.play()

func _on_resume_mouse_entered():
	resume_button.grab_focus()
	audio_stream_player.play()

func _on_restart_focus_entered():
	audio_stream_player.play()

func _on_restart_mouse_entered():
	restart_button.grab_focus()

func _on_main_menu_focus_entered():
	audio_stream_player.play()

func _on_main_menu_mouse_entered():
	main_menu.grab_focus()
	audio_stream_player.play()

func _on_quit_focus_entered():
	audio_stream_player.play()

func _on_quit_mouse_entered():
	quit_button.grab_focus()
	audio_stream_player.play()
#endregion
