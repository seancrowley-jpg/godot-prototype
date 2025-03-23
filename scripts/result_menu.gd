extends Control

@onready var next_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/NextButton
@onready var restart_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/RestartButton
@onready var main_menu_button = $PanelContainer/VBoxContainer/ButtonHBoxContainer3/MainMenuButton
@onready var time_result_label = $PanelContainer/VBoxContainer/TimeHBoxContainer/TimeResultLabel
@onready var alerts_result_label = $PanelContainer/VBoxContainer/AlertsHBoxContainer2/AlertsResultLabel
const FILE_BEGIN = "res://scenes/levels/"

func _ready() -> void:
	next_button.pressed.connect(load_next_level)
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
	time_result_label.set_text(GlobalVariables.level_complete_time)
	alerts_result_label.set_text(str(GlobalVariables.level_alerts))
	#GlobalVariables.total_alerts + GlobalVariables.level_alerts
	next_button.grab_focus()

func load_next_level():
	var current_scene_file = get_tree().current_scene.scene_file_path
	var next_level_number = current_scene_file.to_int() + 1
	var next_level_path = FILE_BEGIN + ("level_" + str(next_level_number)) + ".tscn"
	print(current_scene_file)
	print(next_level_number)
	print(next_level_path)
	if ResourceLoader.exists(next_level_path):
		get_tree().paused = false
		get_tree().change_scene_to_file(next_level_path)
	

func _on_restart_button_pressed():
	restart()

func _on_main_menu_button_pressed():
	GlobalVariables.is_game_over = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/levels/main_menu.tscn")
