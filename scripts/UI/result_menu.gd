extends Control

@onready var next_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/NextButton
@onready var restart_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/RestartButton
@onready var main_menu_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/MainMenuButton
@onready var time_result_label = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/TimeHBoxContainer/TimeResultLabel
@onready var alerts_result_label = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer/AlertsHBoxContainer2/AlertsResultLabel
const FILE_BEGIN = "res://scenes/levels/"
@onready var audio_stream_player = $AudioStreamPlayer
@onready var grade_time = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer/GradeTime
@onready var grade_alert = $PanelContainer/VBoxContainer/HBoxContainer/VBoxContainer2/HBoxContainer2/GradeAlert

var current_level= "level_"

func _ready() -> void:
	next_button.pressed.connect(load_next_level)
	restart_button.pressed.connect(get_tree().reload_current_scene)
	current_level += str(get_tree().current_scene.scene_file_path.to_int())
	
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
	time_result_label.set_text(GlobalVariables.level_complete_time)
	alerts_result_label.set_text(str(GlobalVariables.level_alerts))
	#GlobalVariables.total_alerts + GlobalVariables.level_alerts
	grade_time.set_text(calculate_grade_time())
	grade_alert.set_text(calculate_grade_alert())
	next_button.grab_focus()

func load_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = FILE_BEGIN + ("level_" + str(next_level_number)) + ".tscn"
	if ResourceLoader.exists(next_level_path):
		get_tree().paused = false
		get_tree().change_scene_to_file(next_level_path)
	

func calculate_grade_time() -> String:
	if int(GlobalVariables.level_complete_time) <= GlobalVariables.results_table[current_level]["time"][0]: 
			return "S"
	elif int(GlobalVariables.level_complete_time) <= GlobalVariables.results_table[current_level]["time"][1]: 
			return "A"
	elif int(GlobalVariables.level_complete_time) <= GlobalVariables.results_table[current_level]["time"][2]: 
			return "B"
	elif int(GlobalVariables.level_complete_time) <= GlobalVariables.results_table[current_level]["time"][3]: 
			return "C"
	elif int(GlobalVariables.level_complete_time) <= GlobalVariables.results_table[current_level]["time"][4]: 
			return "D"
	else:
		return "F"
		
func calculate_grade_alert() -> String:
	if GlobalVariables.level_alerts <= GlobalVariables.results_table[current_level]["alerts"][0]: 
			return "S"
	elif GlobalVariables.level_alerts <= GlobalVariables.results_table[current_level]["alerts"][1]: 
			return "A"
	elif GlobalVariables.level_alerts <= GlobalVariables.results_table[current_level]["alerts"][2]: 
			return "B"
	elif GlobalVariables.level_alerts <= GlobalVariables.results_table[current_level]["alerts"][3]: 
			return "C"
	elif GlobalVariables.level_alerts <= GlobalVariables.results_table[current_level]["alerts"][4]: 
			return "D"
	else:
		return "F"

func _on_restart_button_pressed():
	restart()

func _on_main_menu_button_pressed():
	GlobalVariables.is_game_over = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/main_menu.tscn")

#region
## Signals for button sounds and focus
func _on_next_button_focus_entered():
	audio_stream_player.play()

func _on_next_button_mouse_entered():
	audio_stream_player.play()
	next_button.grab_focus()

func _on_restart_button_focus_entered():
	audio_stream_player.play()

func _on_restart_button_mouse_entered():
	audio_stream_player.play()
	restart_button.grab_focus()

func _on_main_menu_button_focus_entered():
	audio_stream_player.play()

func _on_main_menu_button_mouse_entered():
	audio_stream_player.play()
	main_menu_button.grab_focus()
#endregion
