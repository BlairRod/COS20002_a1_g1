extends Node2D

func _process(_delta: float) -> void:
	$TimerLabel.text = "Time Remaining: " + "%s" %  GetTime()

func _on_court_button_pressed():
	get_tree().change_scene_to_file("res://scenes/court.tscn")




func _on_countdown_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/court.tscn")

func GetTime():
	var time = round($CountdownTimer.time_left)
	var seconds = int(time)%60
	var minutes = (int(time)/60)%60
	var hours = (int(time)/60)/60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

# Pause game with "Esc" key or Menu button
func _on_main_button_pressed():
	get_tree().paused = true
	
func _input(event : InputEvent):
	if(event.is_action_pressed("ui_cancel")):
		get_tree().paused = true
