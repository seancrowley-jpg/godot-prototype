extends Control

@onready var texture_button_lvl_1 = $PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl1/TextureButton_lvl_1
@onready var texture_button_lvl_2 = $PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_2/TextureButton_lvl_2
@onready var texture_button_lvl_3 = $PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_3/TextureButton_lvl_3
@onready var texture_button_lvl_4 = $PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_4/TextureButton_lvl_4
@onready var texture_button_lvl_5 = $PanelContainer/VBoxContainer/GridContainer/VBoxContainer_lvl_5/TextureButton_lvl_5
@onready var main_menu_ui = $"../main_menu_ui"
@onready var back_button = $PanelContainer/VBoxContainer/BackButton

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
	visible = false
	main_menu_ui.visible = true
