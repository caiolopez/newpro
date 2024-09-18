extends Control

@onready var load_game_button = $VBoxContainer/LoadGameButton
@onready var new_game_button = $VBoxContainer/NewGameButton
@onready var options_button = $VBoxContainer/OptionsButton
@onready var quit_button = $VBoxContainer/QuitButton
@onready var v_box_container = $VBoxContainer

var is_transitioning = false

func _ready():
	v_box_container.modulate.a = 0
	hide()
	load_game_button.pressed.connect(_on_load_game_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	options_button.pressed.connect(_on_options_pressed)
	quit_button.pressed.connect(_on_quit_pressed)

func show_menu():
	load_game_button.visible = SaveManager.has_valid_save_file()
	v_box_container.modulate.a = 0
	show()
	is_transitioning = true
	var tween = create_tween()
	tween.tween_property(v_box_container, "modulate:a", 1.0, 0.5)
	await tween.finished
	is_transitioning = false
	(load_game_button if load_game_button.visible else new_game_button).grab_focus()

func hide_menu():
	is_transitioning = true
	var tween = create_tween()
	tween.tween_property(v_box_container, "modulate:a", 0.0, 0.5)
	await tween.finished
	is_transitioning = false
	hide()

func _on_options_closed():
	if self.visible:
		options_button.grab_focus()
 
func _on_load_game_pressed():
	Utils.lose_focus()
	await hide_menu()
	Events.request_load_game.emit()

func _on_new_game_pressed():
	if SaveManager.has_valid_save_file():
		var confirmed = await UI.confirmation_menu.ask_for_confirmation(
			"A save file exists. Start a new game anyway?",
			"Start New Game"
		)
		if confirmed:
			await hide_menu()
			Events.request_new_game.emit()
		else:
			new_game_button.grab_focus()
	else:
		Utils.lose_focus()
		await hide_menu()
		Events.request_new_game.emit()

func _on_options_pressed():
	UI.options_menu.show_options()

func _on_quit_pressed():
	var confirmed = await UI.confirmation_menu.ask_for_confirmation(
		"Are you sure you want to quit?",
		"Quit Game"
	)
	if confirmed:
		get_tree().quit()
	else:
		quit_button.grab_focus()

func _unhandled_input(_event):
	if is_transitioning:
		get_viewport().set_input_as_handled()
