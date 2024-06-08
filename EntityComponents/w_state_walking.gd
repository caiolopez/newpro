extends WalkerState

var jump_prone: bool = true

func on_enter():
	pass


func on_process(_delta: float):
	if w.is_in_water:
		machine.set_state("WStateFloating")
		return

	if parent.is_on_floor()\
	and not w.is_target_within_activation_radius():
		machine.set_state("WStateIdle")
		return

	if w.jumps_to_grab_target\
	and parent.is_on_floor()\
	and w.is_target_within_grab_jump_window()\
	and w.target_entity.global_position.y < parent.global_position.y:
		machine.set_state("WStateJumping")
		return

	if w.jumps_at_walls\
	and parent.is_on_floor()\
	and parent.is_on_wall():
		machine.set_state("WStateJumping")
		return

	if not parent.is_on_floor() and parent.velocity.y > 0:
		machine.set_state("WStateFalling")
		return

	if w.climbs_walls\
	and parent.is_on_wall():
		machine.set_state("WStateClimbing")
		return


func on_physics_process(delta: float):
	if w.avoids_pits and w.pit_rc and not w.pit_rc.is_colliding():
		w.step_lateral_mov(delta, false)
		parent.velocity.x = 0
	else:
		w.step_lateral_mov(delta)
	w.step_grav(delta)
	parent.move_and_slide()


func on_exit():
	pass
