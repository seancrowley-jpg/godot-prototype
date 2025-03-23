extends Control

@onready var level_select_button = $main_menu/PanelContainer/VBoxContainer/LevelSelectButton
@onready var exit_button = $main_menu/PanelContainer/VBoxContainer/ExitButton
@onready var main_menu = $main_menu
@onready var level_select_menu = $level_select_menu
@onready var texture_button_lvl_1 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl1/TextureButton_lvl_1
@onready var texture_button_lvl_2 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_2/TextureButton_lvl_2
@onready var texture_button_lvl_3 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_3/TextureButton_lvl_3
@onready var texture_button_lvl_4 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_4/TextureButton_lvl_4
@onready var texture_button_lvl_5 = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_5/TextureButton_lvl_5
@onready var texture_button_lvl_test = $level_select_menu/PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_test/TextureButton_lvl_test
@onready var back_button = $level_select_menu/PanelContainer/VBoxContainer/BackButton


func _ready() -> void:
	level_select_button.grab_focus()
	exit_button.pressed.connect(get_tree().quit)

func _on_level_select_button_pressed():
	main_menu.visible = false
	level_select_button.release_focus()
	level_select_menu.visible = true
	texture_button_lvl_1.grab_focus()
	
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
	
func _on_texture_button_lvl_test_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")

func _on_back_button_pressed():
	level_select_menu.visible = false
	back_button.release_focus()
	main_menu.visible = true
	level_select_button.grab_focus()
