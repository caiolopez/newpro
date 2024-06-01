extends DoorState


func on_enter():
	door.close_d.connect(on_close_door)
	$"../TimerAutoClose".start()
	$"../TimerAutoClose".timeout.connect(on_timeout)


func on_exit():
	door.close_d.disconnect(on_close_door)
	$"../TimerAutoClose".stop()


func on_close_door():
	machine.set_state("StateClosing")


func on_timeout():
	machine.set_state("StateClosing")
