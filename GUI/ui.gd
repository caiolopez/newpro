extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var options_menu = $OptionsMenu
@onready var game_time_label = $GameTimeLabel

func _ready():
	options_menu.options_closed.connect(main_menu._on_options_closed)

func toggle_fullscreen():
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, false)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func set_fullscreen(set_to: bool):
	if set_to:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, false)

func set_igt_visible(state: bool):
	game_time_label.visible = state
