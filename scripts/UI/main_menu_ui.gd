extends Control

@onready var level_select_button = $main_menu/PanelContainer/VBoxContainer/VBoxContainer/LevelSelectButton
@onready var exit_button = $main_menu/PanelContainer/VBoxContainer/VBoxContainer/ExitButton
@onready var main_menu = $main_menu
@onready var level_select_menu = $level_select_menu
@onready var texture_button_lvl_1 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl1/TextureButton_lvl_1
@onready var texture_button_lvl_2 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_2/TextureButton_lvl_2
@onready var texture_button_lvl_3 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_3/TextureButton_lvl_3
@onready var texture_button_lvl_4 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_4/TextureButton_lvl_4
@onready var texture_button_lvl_5 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_5/TextureButton_lvl_5
@onready var texture_button_lvl_6 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_6/TextureButton_lvl_6
@onready var back_button = $level_select_menu/PanelContainer/VBoxContainer/BackButton
@onready var audio_stream_player = $AudioStreamPlayer
@onready var v_box_container = $main_menu/PanelContainer/VBoxContainer/VBoxContainer


func _ready() -> void:
	level_select_button.grab_focus()
	exit_button.pressed.connect(get_tree().quit)

func _input(event):
	if level_select_menu.visible and event.is_action_pressed("gamepad_back") or event.is_action_pressed("ui_cancel"):
		level_select_menu. visible = false
		main_menu.visible = true
		level_select_button.grab_focus()

func _on_level_select_button_pressed():
	main_menu.visible = false
	level_select_button.release_focus()
	level_select_menu.visible = true
	texture_button_lvl_1.grab_focus()

#region
##Level select scene transition signals
func _on_texture_button_lvl_1_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_1.tscn")

func _on_texture_button_lvl_2_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_2.tscn")

func _on_texture_button_lvl_3_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_3.tscn")

func _on_texture_button_lvl_4_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_4.tscn")

func _on_texture_button_lvl_5_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_5.tscn")
	
func _on_texture_button_lvl_6_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level_6.tscn")
#endregion

#region
## Signals for button sounds and focus
func _on_back_button_pressed():
	level_select_menu.visible = false
	back_button.release_focus()
	main_menu.visible = true
	level_select_button.grab_focus()

func _on_exit_button_mouse_entered():
	exit_button.grab_focus()
	audio_stream_player.play()

func _on_level_select_button_mouse_entered():
	level_select_button.grab_focus()
	audio_stream_player.play()

func _on_texture_button_lvl_1_mouse_entered():
	texture_button_lvl_1.grab_focus()
	audio_stream_player.play()
	
func _on_texture_button_lvl_2_mouse_entered():
	texture_button_lvl_2.grab_focus()
	audio_stream_player.play()
	
func _on_texture_button_lvl_3_mouse_entered():
	texture_button_lvl_3.grab_focus()
	audio_stream_player.play()
	
func _on_texture_button_lvl_4_mouse_entered():
	texture_button_lvl_4.grab_focus()
	audio_stream_player.play()
	
func _on_texture_button_lvl_5_mouse_entered():
	texture_button_lvl_5.grab_focus()
	audio_stream_player.play()

func _on_texture_button_lvl_6_mouse_entered():
	texture_button_lvl_6.grab_focus()
	audio_stream_player.play()

func _on_back_button_mouse_entered():
	back_button.grab_focus()
	audio_stream_player.play()

func _on_level_select_button_focus_entered():
	audio_stream_player.play()

func _on_exit_button_focus_entered():
	audio_stream_player.play()

func _on_texture_button_lvl_1_focus_entered():
	audio_stream_player.play()

func _on_texture_button_lvl_2_focus_entered():
	audio_stream_player.play()

func _on_texture_button_lvl_3_focus_entered():
	audio_stream_player.play()

func _on_texture_button_lvl_4_focus_entered():
	audio_stream_player.play()

func _on_texture_button_lvl_5_focus_entered():
	audio_stream_player.play()

func _on_texture_button_lvl_6_focus_entered():
	audio_stream_player.play()

func _on_back_button_focus_entered():
	audio_stream_player.play()
#endregion
