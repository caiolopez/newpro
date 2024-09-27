extends Node

@onready var game_tree = get_node("/root/GameTree")
@onready var state_machine: StateMachine = $StateMachine
var developer_mode: bool = true
var hero: Hero = null
var minimap_node
var is_speedrun_mode: bool = false
var game_time: float = 0.0
var teleporters_are_active: bool = false

signal game_started # Emited when leaving AppStateNewGameInit/AppStateLoadGameInit
signal game_paused # Emited when entering AppStatePausedInGame
signal game_unpaused # Emited when leaving AppStatePausedInGame
signal hero_ready # Emited when AppManager instantiates a new Hero

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	state_machine.start()
	SaveManager.game_saved_to_disk.connect(func():
		UI.notification_label.show_notification("Auto-saved."))

func pause():
	state_machine.set_state("AppStatePausedInGame")

func unpause():
	state_machine.set_state("AppStateInGame")

func set_teleporters_active(state: bool):
	teleporters_are_active = state
	Events.teleporters_activated.emit(state)

func start_fresh():
	SaveManager.clear_dictionary()
	if hero: hero.reset_all_variables()
	BulletManager.return_all_bullets()
	PropManager.return_all_props()
	minimap_node.reset()
	game_time = 0.0
	teleporters_are_active = false

func instantiate_camera() -> Camera2D:
	var camera_scene = preload("res://Camera/Camera.tscn")
	var camera_instance = camera_scene.instantiate()
	game_tree.add_child(camera_instance)
	return camera_instance

func instantiate_hero() -> void:
	if hero:
		push_warning("An instance of Hero already exists.")
		call_deferred("emit_signal", "hero_ready")
		return
	var hero_scene = preload("res://Hero/Hero.tscn")
	var hero_instance = hero_scene.instantiate()
	game_tree.add_child(hero_instance)
	hero = hero_instance
	call_deferred("emit_signal", "hero_ready")
