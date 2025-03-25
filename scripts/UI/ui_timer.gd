extends Control

@onready var label = $Panel/Label

var time = 0
var timer_on = false
var time_format = ""

func _process(delta):
	if !get_tree().paused:
		timer_on = true
	
	if(timer_on):
		time += delta
	
	var mils = fmod(time,1)*100
	var secs = fmod(time,60)
	var mins = fmod(time,60*60) / 60
	
	time_format = "%02d : %02d : %02d" % [mins,secs,mils]
	
	label.set_text(str(time_format))
	GlobalVariables.level_complete_time = time_format

func _input(event):
	if event.is_action_pressed("show_timer") and !visible:
		visible = true
	elif event.is_action_pressed("show_timer") and visible:
		visible = false
