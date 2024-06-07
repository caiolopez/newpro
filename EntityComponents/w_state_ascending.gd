extends WalkerState


func on_enter():
	pass


func on_process(_delta: float):	
	if parent.is_on_wall():
		machine.set_state("WStateClimbing")
		return

	if not w.target_entity.global_position.y < parent.global_position.y:
		machine.set_state("WStateDescending")
		return

func on_physics_process(delta: float):
	if parent.global_position.y > w.last_water_surface + 16:
		parent.velocity.y = w.ASCENDING_VELOCITY
	else:
		parent.velocity.y = w.ASCENDING_VELOCITY * (parent.global_position.y - w.last_water_surface)*delta
	w.step_lateral_mov(delta)

	parent.move_and_slide()


func on_exit():
	pass
