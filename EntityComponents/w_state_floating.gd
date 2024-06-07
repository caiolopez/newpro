extends WalkerState


func on_enter():
	pass


func on_process(_delta: float):
	if w.sinks_on_water:
		machine.set_state("WStateDescending")
		return
	
	if parent.is_on_wall():
		machine.set_state("WStateClimbing")
		return


func on_physics_process(delta: float):
	parent.velocity.y = (parent.velocity.y - (w.BUOYANCY * (parent.global_position.y - (w.last_water_surface))*delta))*pow(0.94, 1-delta)
	w.step_grav(delta)
	w.step_lateral_mov(delta)
	parent.move_and_slide()


func on_exit():
	pass

