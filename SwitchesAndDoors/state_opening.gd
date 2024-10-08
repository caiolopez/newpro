extends DoorState


func on_enter():
	door.tween_door_to_offset()
	door.stopped_moving_at_offset.connect(on_stopped_moving)
	door.should_close.connect(on_close_door)


func on_exit():
	door.stopped_moving_at_offset.disconnect(on_stopped_moving)
	if door.should_close.is_connected(on_close_door):
		door.should_close.disconnect(on_close_door)


func on_stopped_moving():
	machine.set_state("DoorStateOpen")


func on_close_door():
	machine.set_state("DoorStateClosing")
