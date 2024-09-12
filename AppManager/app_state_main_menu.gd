extends AppState

@onready var main_menu = UI.get_node("MainMenu")

func on_enter():
	main_menu.show_menu()
	Events.request_new_game.connect(_on_request_new_game, CONNECT_ONE_SHOT)
	Events.request_load_game.connect(_on_request_load_game, CONNECT_ONE_SHOT)

func on_exit():
	main_menu.hide()

func _on_request_new_game() -> void:
	if machine.is_current_state("AppStateMainMenu"):
		machine.set_state("AppStateNewGameInit")

func _on_request_load_game() -> void:
	if machine.is_current_state("AppStateMainMenu"):
		machine.set_state("AppStateLoadGameInit")
	
