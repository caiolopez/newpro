extends DoorState


func on_enter():
	door.should_open.connect(on_open_door)


func on_exit():
	door.should_open.disconnect(on_open_door)


func on_open_door():
	machine.set_state("StateOpening")
