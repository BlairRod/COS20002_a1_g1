extends Node2D

func _on_start_timer_timeout():
	Start_Game()

func Start_Game():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

