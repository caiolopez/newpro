extends DoorState


func on_enter():
	if door.auto_close_time > 0:
		machine.set_state("StateTemporarilyOpen")
		return
	door.close_d.connect(on_close_door)


func on_exit():
	door.close_d.disconnect(on_close_door)


func on_close_door():
	machine.set_state("StateClosing")
