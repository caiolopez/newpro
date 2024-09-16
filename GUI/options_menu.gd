extends Control

signal options_closed
@onready var music_slider = $VBoxContainer/HBoxContainerMusic/MusicSlider
@onready var sfx_slider = $VBoxContainer/HBoxContainerSfx/SfxSlider
@onready var blunder_opt = $VBoxContainer/DedicatedBlunderToggle
@onready var speedrun_opt = $VBoxContainer/SpeedrunModeToggle
@onready var fullscreen_opt = $VBoxContainer/FullscreenToggle
@onready var all_powerups_button = $VBoxContainer/AllPowerups
@onready var back_button = $VBoxContainer/BackButton

var options_data = {
	"music_volume": 1.0,
	"sfx_volume": 1.0,
	"dedicated_blunder": false,
	"speedrun_mode": false,
	"fullscreen": false
}

func _ready():
	hide()
	load_options()
	
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	blunder_opt.toggled.connect(_on_blunder_opt_changed)
	speedrun_opt.toggled.connect(_on_speedrun_opt_changed)
	fullscreen_opt.toggled.connect(_on_fullscreen_changed)
	all_powerups_button.pressed.connect(_grant_all_powerups)
	back_button.pressed.connect(close_options)

func show_options():
	show()
	music_slider.grab_focus()

func close_options():
	hide()
	save_options()
	options_closed.emit()

func _on_music_volume_changed(value):
	options_data["music_volume"] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_sfx_volume_changed(value):
	options_data["sfx_volume"] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func _on_blunder_opt_changed(state: bool):
	options_data["dedicated_blunder"] = state
	if Utils.find_hero():
		Utils.find_hero().dedicated_blunder_button = state

func _on_speedrun_opt_changed(state: bool):
	print("changed from ", )
	options_data["speedrun_mode"] = state
	AppManager.is_speedrun_mode = state
	UI.call_deferred("set_igt_visible", state)

func _on_fullscreen_changed(state: bool):
	options_data["fullscreen"] = state
	UI.set_fullscreen(state)

func _grant_all_powerups():
	if not Utils.find_hero(): return
	var hero = Utils.find_hero()
	hero.handle_powerups("INCENDIARY_AMMO")
	hero.handle_powerups("UNDERWATER_AMMO")
	hero.handle_powerups("AQUALUNG")
	hero.handle_powerups("TELEPORTER")

func save_options():
	var file = FileAccess.open("user://options.save", FileAccess.WRITE)
	file.store_var(options_data)
	file.close()

func load_options():
	if FileAccess.file_exists("user://options.save"):
		var file = FileAccess.open("user://options.save", FileAccess.READ)
		var loaded_data = file.get_var()
		file.close()
		for key in loaded_data:
			if key in options_data:
				options_data[key] = loaded_data[key]
	apply_loaded_options()

func apply_loaded_options():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(options_data["music_volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(options_data["sfx_volume"]))
	music_slider.value = options_data["music_volume"]
	sfx_slider.value = options_data["sfx_volume"]
	
	blunder_opt.button_pressed = options_data["dedicated_blunder"]
	if Utils.find_hero():
		Utils.find_hero().dedicated_blunder_button = options_data["dedicated_blunder"]

	speedrun_opt.button_pressed = options_data["speedrun_mode"]
	AppManager.is_speedrun_mode = options_data["speedrun_mode"]
	UI.call_deferred("set_igt_visible", options_data["speedrun_mode"])

	fullscreen_opt.button_pressed = options_data["fullscreen"]
	UI.set_fullscreen(options_data["fullscreen"])
