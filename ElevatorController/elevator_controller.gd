extends Node

@export var elevator: Elevator


func push_origin():
	if elevator == null:
		push_warning("No elevator is linked to ", self.name, ". Nothing will happen.")
		return
	elevator.tween_to_start()


func push_destination():
	if elevator == null:
		push_warning("No elevator is linked to ", self.name, ". Nothing will happen.")
		return
	elevator.tween_to_end()
