extends Control


func _ready() -> void:
	hide()
	AppManager.game_paused.connect(_show_menu)
	AppManager.game_unpaused.connect(_hide_menu)
	$VBoxContainer/ResumeButton.pressed.connect(AppManager.unpause)
	$VBoxContainer/OptionsButton.pressed.connect(func(): UI.options_menu.show_options())
	$VBoxContainer/QuitButton.pressed.connect(_on_quit_to_main)

func _show_menu() -> void:
	show()
	$VBoxContainer/ResumeButton.grab_focus()

func _hide_menu() -> void:
	hide()

func _on_options_closed() -> void:
	if self.visible:
		$VBoxContainer/OptionsButton.grab_focus()

func _on_quit_to_main() -> void:
	AppManager.state_machine.set_state("AppStateMainMenu") # TODO this should be an app_state
	Events.curtain_fade_in.emit()
