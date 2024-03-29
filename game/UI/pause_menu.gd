extends Control

@export var cell_manager : CellManager

# https://www.youtube.com/watch?v=OWtwYp2lIlQ

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	cell_manager.connect("toggle_game_paused", _on_cell_manager_toggle_game_paused)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func _on_cell_manager_toggle_game_paused(is_paused : bool) -> void:
	if(is_paused):
		show()
		$OpenSound.play()
	else:
		hide()

func _on_resume_button_pressed() -> void:
	cell_manager.game_paused = false


func _on_main_button_pressed() -> void:
	#cell_manager.game_paused = false
	#SceneSwitcher.switch_scene("res://scenes/main.tscn")
	get_tree().quit()
