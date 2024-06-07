extends WalkerState


func on_enter():
	pass


func on_process(_delta: float):
	if not parent.is_on_wall():
		machine.set_state("WStateWalking")
		return

	if w.is_target_within_activation_radius():
		parent.velocity.y = -w.CLIMBING_SPEED
	else:
		parent.velocity.y = 0

func on_physics_process(delta: float):
	w.step_lateral_mov(delta)
	parent.move_and_slide()


func on_exit():
	pass
