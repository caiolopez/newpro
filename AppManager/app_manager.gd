extends Node

var game_time: float = 0.0
var is_time_running: bool = false

func _process(delta):
	if is_time_running and not get_tree().paused:
		game_time += delta
