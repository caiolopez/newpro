extends HeroState

func on_enter():
	if hero.is_on_wall_only() and Input.is_action_just_pressed('jump'):
		get_node("../TimerCoyoteWallJumpC").start()
		print('CCC')
	if not hero.is_on_wall() and Input.is_action_just_pressed('jump'):
		get_node("../TimerBufferWallJump").start()

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
	if not Input.is_action_pressed("jump"):
		machine.set_state("StateFalling")
		return
	if hero.is_pushing_wall()\
		and not get_node("../TimerBufferWallJump").is_stopped():
		get_node("../TimerBufferWallJump").stop()
		machine.set_state("StateWallClimbing")
		return
	if hero.is_pushing_wall():
		machine.set_state("StateWallGrabbing")
		return
	if hero.is_move_dir_away_from_last_wall(false)\
	and not get_node("../TimerCoyoteWallJumpC").is_stopped():
		get_node("../TimerCoyoteWallJumpC").stop()
		print("ccc")
		machine.set_state("StateWallJumping")
		return


	if Input.is_action_pressed("jump"): hero.velocity.y = hero.GLIDE_VELOCITY
	
	if hero.is_on_wall_only() and hero.is_move_dir_away_from_last_wall(true):
		get_node("../TimerCoyoteWallJumpB").start()
		print('BBB')
	
	hero.step_lateral_mov(delta)
	
	
	hero.move_and_slide()


func on_exit():
	pass
