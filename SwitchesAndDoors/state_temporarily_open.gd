extends DoorState


func on_enter():
	door.close_d.connect(on_close_door)
	$"../TimerAutoClose".start()
	$"../TimerAutoClose".timeout.connect(on_timeout)


func on_exit():
	pass


func on_close_door():
	if machine.current_state != self:
		return
	machine.set_state("StateClosing")
	door.tween_door_to_origin()


func on_timeout():
	if machine.current_state != self:
		return
	machine.set_state("StateClosing")
	door.tween_door_to_origin()
	
