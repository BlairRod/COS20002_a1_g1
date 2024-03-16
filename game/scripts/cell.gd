extends Node2D

# All timers setup
@onready var cd_timer : Timer = $CountdownTimer
@onready var voice_timer : Timer = $SoundTimer
@onready var hide_line_timer : Timer = $HideLineTimer
@onready var input_text_edit : TextEdit = $CanvasLayer/Control/Notepad/MarginContainer/Panel/VBoxContainer/TextEdit

# Global variables and arrays
var rng
var bs_array = []				# The written bs lines
var main_array = []				# The written main lines
var voice_location = []			# Location of all voice nodes in the cell scene
var bs_voices_array = []		# The spoken bs lines
var main_voices_array = []		# The spoken main lines
var input_text					# Text from TextEdit
var line : Label				# The current label node
var main_lines_played : int		# How many of the main lines have been played in the game loop
var bs_lines_played : int		# How many of the bs lines have been played in the game loop
var main_line_chance : int		# Chance of main voice being selected
var main_sound_show : bool


# Setup function, calls on scene start
func _ready() -> void:
	rng = RandomNumberGenerator.new()
	main_lines_played = 0
	bs_lines_played = 0
	main_line_chance = 0
	$CanvasLayer/SoundAlertImage.hide()
	main_sound_show = false
	setup_timers()
	call_deferred("setup_arrays")

# Game loop function, calls every delta time
func _process(_delta: float) -> void:
	$CanvasLayer/TimerLabelcd.text = "Time Remaining: " + "%s" %  GetTime()

# Sets up timer wait times and sarts timers
func setup_timers():
	cd_timer.wait_time = 300
	voice_timer.wait_time = 2
	hide_line_timer.wait_time = voice_timer.wait_time / 2
	cd_timer.start()
	voice_timer.start()

# Calls arrays from global singleton, and ssets up all oter arrays
func setup_arrays():
	# bs and main arrays are called from GlobalSingleton, their setups are in cell manager
	bs_array.append_array(GlobalSingleton.bs_array)
	main_array.append_array(GlobalSingleton.main_array)
	var location			# The node path voice locations
	var voice_file			# The resource path of voice files/mp3
	var index = 1
	# Adds all voice node locations to voice location array
	while(index <= 8):
		location = "Voices/voice" + str(index) + "/AudioStreamPlayer2D"
		voice_location.append(location)
		index += 1
	index = 1
	# Adds all bs voice resources/mp3s to bs voice file array
	while(index < bs_array.size()):
		voice_file = "res://sounds/voice/bs_lines/bs_voice_" + str(index) + ".mp3"
		bs_voices_array.append(voice_file)
		index += 1
	index = 1
	# Adds all main voice resources/mp3s to main voice file array
	while(index < main_array.size()):
		voice_file = "res://sounds/voice/main_lines/main_voice_" + str(index) + ".mp3"
		main_voices_array.append(voice_file)
		index += 1

# Button event for go to court button, switches to court scene
func _on_court_button_pressed() -> void:
	input_text = input_text_edit.text
	GlobalSingleton.notepad_text = input_text
	SceneSwitcher.switch_scene("res://scenes/court.tscn")

# Event for countdown timer, ends scene when time runs out, switches to court scene
func _on_countdown_timer_timeout() -> void:
	input_text = input_text_edit.text
	GlobalSingleton.notepad_text = input_text
	SceneSwitcher.switch_scene("res://scenes/court.tscn")

# Returns formatted time string hh:mm:ss
func GetTime():
	var time = round(cd_timer.time_left)
	var seconds = int(time)%60
	var minutes = (int(time)/60)%60
	var hours = (int(time)/60)/60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

# Event for sound timer, main game loop content
func _on_sound_timer_timeout() -> void:
	var index
	var sound_node : AudioStreamPlayer2D
	rng.randomize()
	index = rng.randi_range(0, voice_location.size() - 1)
	line = get_node("LinesCanvasLayer/line" + str(index + 1))
	sound_node = get_node(voice_location[index])
	rng.randomize()
	if(play_main()):
		index = rng.randi_range(0, main_array.size() - 2)
		line.text = main_array[main_lines_played]
		var sound_path = main_voices_array[main_lines_played]
		var file = FileAccess.open(sound_path, FileAccess.READ)
		var buffer = file.get_buffer(file.get_length())
		var stream = AudioStreamMP3.new()
		stream.data = buffer
		sound_node.stream = stream
		sound_node.play()
		hide_line_timer.start()
		file.close()
		main_line_chance = 0
		main_lines_played += 1
		$CanvasLayer/SoundAlertImage.show()
		main_sound_show = true
		print_debug("Main: " + str(main_lines_played))
	else:
		index = rng.randi_range(0, bs_array.size() - 2)
		line.text = bs_array[index]
		var sound_path = bs_voices_array[index]
		var file = FileAccess.open(sound_path, FileAccess.READ)
		var buffer = file.get_buffer(file.get_length())
		var stream = AudioStreamMP3.new()
		stream.data = buffer
		sound_node.stream = stream
		sound_node.play()
		hide_line_timer.start()
		main_line_chance += 1
		file.close()
		bs_lines_played += 1
		print_debug("BS: " + str(bs_lines_played))

# Event for hide kine timer, hides the current displayed voice line text
func _on_hide_line_timer_timeout() -> void:
	line.text = ""
	if(main_sound_show):
		$CanvasLayer/SoundAlertImage.hide()
		main_sound_show = false

# Returns true if a main line should be played with increasing chance if one hasn't been played in a while
func play_main():
	if(main_lines_played == main_array.size() - 1):
		main_line_chance = 0
	rng.randomize()
	var index
	index = rng.randi_range(0, main_line_chance * 2)
	if(index >= 5):
		return true
	else:
		return false


