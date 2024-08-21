extends Node

@onready var state_machine: StateMachine = $StateMachine
var game_time: float = 0.0
var is_time_running: bool = false

func _ready() -> void:
	state_machine.start()

func _process(delta):
	if is_time_running and not state_machine.is_current_state("AppStatePaused"):
		game_time += delta
