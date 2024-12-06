extends CanvasLayer

@onready var main_menu = $MainMenu
@onready var pause_menu = $PauseMenu
@onready var options_menu = $OptionsMenu
@onready var confirmation_menu = $ConfirmationMenu
@onready var game_time_label = $GameTimeLabel
@onready var curtain = $BlackCurtain
@onready var screen_flash = $ScreenFlash
@onready var notification_label = $OnScreenNotificationLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if options_menu.visible:
			options_menu.close_options()
		elif pause_menu.visible:
			AppManager.unpause()

func toggle_fullscreen():
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, false)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func set_fullscreen(set_to: bool):
	if set_to:
		if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_NO_FOCUS, false)

func set_igt_visible(state: bool):
	game_time_label.visible = state
