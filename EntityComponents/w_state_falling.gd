extends WalkerState


func on_enter():
	pass


func on_process(_delta: float):
	if w.is_in_water:
		machine.set_state("WStateFloating")
		return

	if parent.is_on_floor():
		machine.set_state("WStateIdle")
		return


func on_physics_process(delta: float):
	w.step_lateral_mov(delta, false)
	w.step_grav(delta, w.FAST_FALL_GRAVITY)
	parent.move_and_slide()


func on_exit():
	pass
