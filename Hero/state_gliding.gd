extends HeroState

func on_enter():
	if hero.is_on_wall_only():
		get_node("../TimerCoyoteWallJump").start()

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
	if not Input.is_action_pressed("jump"):
		machine.set_state("StateFalling")
		return
	if hero.is_pushing_wall():
		machine.set_state("StateWallGrabbing")
		return
	if hero.is_move_dir_away_from_last_wall()\
	and not get_node("../TimerCoyoteWallJump").is_stopped():
		machine.set_state("StateWallJumping")
		print("****************")
		return
	



	if Input.is_action_pressed("jump"): hero.velocity.y = hero.GLIDE_VELOCITY
	
	if hero.is_on_wall_only() and hero.is_move_dir_away_from_last_wall():
		get_node("../TimerCoyoteWallJump").start()
	
	hero.step_lateral_mov(delta)
	
	
	hero.move_and_slide()


func on_exit():
	pass
