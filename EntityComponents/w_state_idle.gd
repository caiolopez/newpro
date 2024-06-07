extends WalkerState


func on_enter():
	parent.velocity.x = 0


func on_process(_delta: float):	
	if parent.is_on_floor()\
	and w.is_target_within_activation_ring():
		machine.set_state("WStateWalking")
		return

	if w.jumps_to_grab_target\
	and parent.is_on_floor()\
	and w.is_target_within_grab_jump_window()\
	and w.target_entity.global_position.y < parent.global_position.y:
		machine.set_state("WStateJumping")
		return

	if not parent.is_on_floor()\
	and parent.velocity.y > 0:
		machine.set_state("WStateFalling")
		return

func on_physics_process(delta: float):
	w.step_grav(delta)
	parent.move_and_slide()


func on_exit():
	pass
