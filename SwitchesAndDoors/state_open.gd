extends DoorState


func on_enter():
	if door.auto_close_time > 0:
		machine.set_state("DoorStateTemporarilyOpen")
		return
	door.should_close.connect(on_close_door)


func on_exit():
	if door.should_close.is_connected(on_close_door):
		door.should_close.disconnect(on_close_door)


func on_close_door():
	machine.set_state("DoorStateClosing")
