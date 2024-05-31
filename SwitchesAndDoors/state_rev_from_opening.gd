extends DoorState


func on_enter():
	print(machine)
	pass


func on_exit():
	door.door_tween.finished.disconnect(on_tween_finished)
	pass


func on_tween_finished():
	pass
	#print(machine)
	#if machine.current_state != self:
		#return
	#if door.auto_close_time <= 0:
		#machine.set_state("StateOpen")
	#else:
		#machine.set_state("StateTemporarilyOpen")
