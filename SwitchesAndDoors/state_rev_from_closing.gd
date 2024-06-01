extends DoorState


func on_enter():
	door.tween_door_to_offset()
	door.stopped_moving_at_offset.connect(on_stopped_moving)


func on_exit():
	door.stopped_moving_at_offset.disconnect(on_stopped_moving)


func on_stopped_moving():
	machine.set_state("StateClosing")
