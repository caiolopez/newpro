extends AppState

@onready var main_menu = UI.get_node("MainMenu")

func on_enter():
	get_tree().paused = true
	AppManager.start_fresh()
	main_menu.show_menu()
	AudioManager.play_music("main_menu")
	Events.request_new_game.connect(_on_request_new_game)
	Events.request_load_game.connect(_on_request_load_game)

func on_exit():
	Events.request_new_game.disconnect(_on_request_new_game)
	Events.request_load_game.disconnect(_on_request_load_game)
	main_menu.hide()

func _on_request_new_game() -> void:
	if machine.is_current_state("AppStateMainMenu"):
		machine.set_state("AppStateNewGameInit")

func _on_request_load_game() -> void:
	if machine.is_current_state("AppStateMainMenu"):
		machine.set_state("AppStateLoadGameInit")
	
