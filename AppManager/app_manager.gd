extends Node

@onready var state_machine: StateMachine = $StateMachine
var game_time: float = 0.0
var is_time_running: bool = false

signal game_paused
signal game_unpaused

func _ready() -> void:
	state_machine.start()

func pause():
	state_machine.set_state("AppStatePaused")

func unpause():
	state_machine.set_state("AppStateInGame")
