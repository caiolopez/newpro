extends WalkerState

var jump_prone: bool = true

func on_enter():
	parent.velocity.x = 0
	for area in w.get_overlapping_areas():
		if area is Bullet:
			machine.set_state("WStateJumpingBullet")


func on_process(_delta: float):
	if w.is_in_water:
		machine.set_state("WStateFloating")
		return
	
	if parent.is_on_floor()\
	and w.is_target_within_activation_radius():
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
