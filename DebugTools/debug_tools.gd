extends Node2D

@export var print_stuff: bool = true
@export var input_stuff: bool = true

func _ready():
	ComboParser.combo_performed.connect(func(combo):
		if combo == "FullScreen": toggle_fullscreen())

func _process(_delta):
	input_bin()
	print_bin()

func input_bin():
	if not input_stuff: return
	if Input.is_action_just_pressed("Debug Action 1"):
		SaveManager.print_all_dics()
	if Input.is_action_just_pressed("Debug Action 2"):
		print(Utils.parse_time_as_string(AppManager.game_time, false))


func print_bin():
	if not print_stuff: return

func toggle_fullscreen():
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
