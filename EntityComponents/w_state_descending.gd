extends WalkerState


func on_enter():
	pass


func on_process(_delta: float):	
	if w.target_entity.global_position.y < parent.global_position.y:
		machine.set_state("WStateAscending")
		return

func on_physics_process(delta: float):
	w.step_grav(delta, w.UNDERWATER_GRAVITY)
	w.step_lateral_mov(delta)
	parent.velocity.y = minf(parent.velocity.y,w.MAX_DESCENT_VEL_Y)
	parent.move_and_slide()


func on_exit():
	pass
