extends DoorState


func on_enter():
	door.open_d.connect(on_open_door)


func on_exit():
	door.open_d.disconnect(on_open_door)


func on_open_door():
	if machine.current_state != self:
		return
	machine.set_state("StateOpening")
	door.tween_door_to_offset()
