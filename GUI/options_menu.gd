extends Control

signal options_closed
@onready var music_slider = $VBoxContainer/HBoxContainerMusic/MusicSlider
@onready var sfx_slider = $VBoxContainer/HBoxContainerSfx/SfxSlider
@onready var blunder_opt = $VBoxContainer/DedicatedBlunderToggle
@onready var physics_opt = $VBoxContainer/PhysicsInterpolationToggle
@onready var speedrun_opt = $VBoxContainer/SpeedrunModeToggle
@onready var background_opt = $VBoxContainer/RenderBackgroundToggle
@onready var accessibility_opt = $VBoxContainer/AccessibilityToggle
@onready var fullscreen_opt = $VBoxContainer/FullscreenToggle
@onready var all_powerups_button = $VBoxContainer/AllPowerups
@onready var back_button = $VBoxContainer/BackButton

var options_data = {
	"music_volume": 1.0,
	"sfx_volume": 1.0,
	"dedicated_blunder": true,
	"physics_interpolation": false,
	"speedrun_mode": false,
	"render_background": true,
	"accessibility_mode": true,
	"fullscreen": false
}

func _ready():
	hide()
	load_options()
	
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	blunder_opt.toggled.connect(_on_blunder_opt_changed)
	physics_opt.toggled.connect(_on_physics_opt_changed)
	speedrun_opt.toggled.connect(_on_speedrun_opt_changed)
	background_opt.toggled.connect(_on_render_background_changed)
	accessibility_opt.toggled.connect(_on_accessibility_changed)
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
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))

func _on_sfx_volume_changed(value):
	options_data["sfx_volume"] = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))

func _on_blunder_opt_changed(state: bool):
	options_data["dedicated_blunder"] = state
	AppManager.dedicated_blunder_button = state

func _on_physics_opt_changed(state: bool):
	options_data["physics_interpolation"] = state
	Engine.physics_jitter_fix = 0.0 if state else 0.5
	get_tree().physics_interpolation = state

func _on_speedrun_opt_changed(state: bool):
	options_data["speedrun_mode"] = state
	AppManager.is_speedrun_mode = state
	UI.call_deferred("set_igt_visible", state)

func _on_render_background_changed(state: bool):
	options_data["render_background"] = state
	BackgroundManager.call_deferred("set_render_backgrounds", state)

func _on_accessibility_changed(state: bool):
	options_data["accessibility_mode"] = state
	AppManager.is_accessibility_mode = state
	if AppManager.hero:
		AppManager.hero.tint_as_accessibility()

func _on_fullscreen_changed(state: bool):
	options_data["fullscreen"] = state
	UI.set_fullscreen(state)

func _grant_all_powerups():
	var hero = AppManager.hero
	if not hero: return
	hero.handle_powerups("INCENDIARY_AMMO")
	hero.handle_powerups("UNDERWATER_AMMO")
	hero.handle_powerups("AQUALUNG")
	hero.handle_powerups("TELEPORTER")

func save_options():
	var config = ConfigFile.new()
	for key in options_data:
		config.set_value("Settings", key, options_data[key])
	config.save("user://options.cfg")

func load_options():
	var config = ConfigFile.new()
	var err = config.load("user://options.cfg")
	if err == OK:
		for key in options_data:
			if config.has_section_key("Settings", key):
				options_data[key] = config.get_value("Settings", key)

	apply_loaded_options()

func apply_loaded_options():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(options_data["music_volume"]))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(options_data["sfx_volume"]))
	music_slider.value = options_data["music_volume"]
	sfx_slider.value = options_data["sfx_volume"]

	AppManager.dedicated_blunder_button = options_data["dedicated_blunder"]
	blunder_opt.button_pressed = options_data["dedicated_blunder"]

	get_tree().physics_interpolation = options_data["physics_interpolation"]
	Engine.physics_jitter_fix = 0.0 if options_data["physics_interpolation"] else 0.5
	physics_opt.button_pressed = options_data["physics_interpolation"]

	AppManager.is_speedrun_mode = options_data["speedrun_mode"]
	speedrun_opt.button_pressed = options_data["speedrun_mode"]
	UI.call_deferred("set_igt_visible", options_data["speedrun_mode"])

	BackgroundManager.call_deferred("set_render_backgrounds", options_data["render_background"])
	background_opt.button_pressed = options_data["render_background"]

	AppManager.is_accessibility_mode = options_data["accessibility_mode"]
	accessibility_opt.button_pressed = options_data["accessibility_mode"]
	if AppManager.hero:
		AppManager.hero.tint_as_accessibility()

	fullscreen_opt.button_pressed = options_data["fullscreen"]
	UI.set_fullscreen(options_data["fullscreen"])
