extends Node

@onready var curtain = UI.get_node("BlackCurtain")
@onready var game_tree = get_node("/root/GameTree")
@onready var state_machine: StateMachine = $StateMachine
var minimap_node
var game_time: float = 0.0
var teleporters_are_active: bool:
	set(value):
		teleporters_are_active = value
		Events.teleporters_activated.emit(value)

signal game_started
signal game_paused
signal game_unpaused

func _ready() -> void:
	state_machine.start()

func pause():
	state_machine.set_state("AppStatePaused")

func unpause():
	state_machine.set_state("AppStateInGame")
