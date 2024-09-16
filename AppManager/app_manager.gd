extends Node

@onready var curtain = UI.get_node("BlackCurtain")
@onready var game_tree = get_node("/root/GameTree")
@onready var state_machine: StateMachine = $StateMachine
var minimap_node
var is_speedrun_mode: bool = false
var game_time: float = 0.0
var teleporters_are_active: bool = false

signal game_started
signal game_paused
signal game_unpaused

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	state_machine.start()

func pause():
	state_machine.set_state("AppStatePaused")

func unpause():
	state_machine.set_state("AppStateInGame") 

func set_teleporters_active(state: bool):
	teleporters_are_active = state
	Events.teleporters_activated.emit(state)

func start_fresh():
	SaveManager.clear_dictionary()
	Utils.find_hero().reset_all_variables()
	BulletManager.free_all_bullets()
	game_time = 0.0
	teleporters_are_active = false
