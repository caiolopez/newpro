extends DoorState


func on_enter():
	door.tween_door_to_offset()
	door.stopped_moving_at_offset.connect(on_stopped_moving)
	door.close_d.connect(on_close_door)


func on_exit():
	door.stopped_moving_at_offset.disconnect(on_stopped_moving)
	door.close_d.disconnect(on_close_door)


func on_stopped_moving():
	if door.auto_close_time <= 0:
		machine.set_state("StateOpen")
	else:
		machine.set_state("StateTemporarilyOpen")


func on_close_door():
	machine.set_state("StateClosing")
