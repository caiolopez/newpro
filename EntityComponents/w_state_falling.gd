extends WalkerState


func on_enter():
	pass


func on_process(_delta: float):
	if parent.is_on_floor():
		machine.set_state("WStateIdle")
		return


func on_physics_process(delta: float):
	w.step_lateral_mov(delta)
	w.step_grav(delta)
	parent.move_and_slide()


func on_exit():
	pass
