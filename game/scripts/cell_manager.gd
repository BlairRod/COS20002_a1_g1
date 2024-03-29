extends Node

class_name CellManager

signal toggle_game_paused(is_paused : bool)

const BS_TEXT_FILE = "res://texts/bs_lines.txt"
const MAIN_TEXT_FILE = "res://texts/main_lines.txt"

var game_paused : bool = false:
	get:
		return game_paused
	set(value):
		game_paused = value
		get_tree().paused = game_paused
		emit_signal("toggle_game_paused", game_paused)

var bs_array = []
var main_array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bs_array = load_lines(BS_TEXT_FILE)
	GlobalSingleton.bs_array.append_array(bs_array)
	main_array = load_lines(MAIN_TEXT_FILE)
	GlobalSingleton.main_array.append_array(main_array)
	#print_debug("Main Line 2: " + main_array[1])
	#print_debug("BS Line 2: " + bs_array[1])

## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass

func load_lines(input_file):
	#if(FileAccess.file_exists(input_file)):
	var output_array = []
	#var lines_res = input_file
	var file = FileAccess.open(input_file, FileAccess.READ)
	while(!file.eof_reached()):
		var file_line = file.get_line()
		output_array.append(file_line)
	file.close()
	return output_array
		
func _input(event : InputEvent) -> void:
	if(event.is_action_pressed("ui_cancel")):
		game_paused = !game_paused
