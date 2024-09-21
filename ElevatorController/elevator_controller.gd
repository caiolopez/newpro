class_name ElevatorController extends Node

@export var elevator: Elevator

func send_elevator_to(where: StringName):
	if elevator == null:
		push_warning("No elevator is linked to ", self.name, ". Nothing will happen.")
		return
	if where == &"origin":
		elevator.tween_to_start()
	else:
		elevator.tween_to_end()
