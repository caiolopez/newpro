extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_on_floor(): machine.set_state("StateIdle")
	if Input.is_action_just_pressed('jump') and hero.is_pushing_wall():
		machine.set_state("StateWallClimbing")
		return
	if Input.is_action_just_pressed('jump')\
		and not get_node("../TimerCoyoteJump").is_stopped():
		machine.set_state("StateJumping")
		return
	if not get_node("../TimerCoyoteWallJumpB").is_stopped() \
		and Input.is_action_just_pressed('jump'):
		machine.set_state("StateWallJumping")
		print('bbb')
		return
	if not get_node("../TimerCoyoteWallJumpA").is_stopped() \
		and Input.is_action_just_pressed('jump'):
		machine.set_state("StateWallJumping")
		print('aaa')
		return
	if Input.is_action_pressed('jump'): machine.set_state("StateGliding")
	
	
	
	if Input.is_action_just_pressed('jump'):
		get_node("../TimerBufferJump").start()
		
	if hero.is_on_wall_only() and hero.is_move_dir_away_from_last_wall(true):
		get_node("../TimerCoyoteWallJumpA").start()
		print("AAA")
		
			
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
