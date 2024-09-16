extends Control

@onready var load_game_button = $VBoxContainer/LoadGameButton

func _ready():
	hide()
	$VBoxContainer/LoadGameButton.pressed.connect(func(): Events.request_load_game.emit())
	$VBoxContainer/NewGameButton.pressed.connect(func(): Events.request_new_game.emit())
	$VBoxContainer/OptionsButton.pressed.connect(func(): UI.options_menu.show_options())
	$VBoxContainer/QuitButton.pressed.connect(func(): get_tree().quit())

func show_menu():
	show()
	load_game_button.visible = SaveManager.has_valid_save_file()
	(load_game_button if load_game_button.visible else $VBoxContainer/NewGameButton).grab_focus()

func _on_options_closed():
	if self.visible:
		$VBoxContainer/OptionsButton.grab_focus()
