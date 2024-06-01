extends DoorState


func on_enter():
	door.open_d.connect(on_open_door)


func on_exit():
	door.open_d.disconnect(on_open_door)


func on_open_door():
	machine.set_state("StateOpening")
