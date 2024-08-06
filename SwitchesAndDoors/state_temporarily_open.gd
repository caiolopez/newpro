extends DoorState


func on_enter():
	door.should_close.connect(on_close_door)
	$"../TimerAutoClose".start()
	if not $"../TimerAutoClose".timeout.is_connected(on_timeout):
		$"../TimerAutoClose".timeout.connect(on_timeout)


func on_exit():
	door.should_close.disconnect(on_close_door)
	$"../TimerAutoClose".stop()


func on_close_door():
	machine.set_state("StateClosing")


func on_timeout():
	machine.set_state("StateClosing")
