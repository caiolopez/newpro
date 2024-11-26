extends DoorState


func on_enter():
	door.should_close.connect(on_close_door)


func on_exit():
	if door.should_close.is_connected(on_close_door):
		door.should_close.disconnect(on_close_door)


func on_close_door():
	machine.set_state("DoorStateClosing")
