extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	if hero.is_on_wall_value_change()\
	and not hero.is_on_wall():
		get_node("../TimerLeavingWall").start()
		print('LEFT WALL - FALLING')
		
	if Input.is_action_just_pressed('jump')\
		and not get_node("../TimerBlunderJumpWindow").is_stopped():
		machine.set_state("StateBlunderJumping")
		return
	if not get_node("../TimerLeavingWall").is_stopped()\
	and Input.is_action_just_pressed('jump')\
	and hero.is_move_dir_away_from_last_wall(false):
		get_node("../TimerLeavingWall").stop()
		machine.set_state("StateWallJumping")
		return		
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.is_on_floor(): machine.set_state("StateIdle")
	if Input.is_action_just_pressed('jump') and hero.is_pushing_wall():
		machine.set_state("StateWallClimbing")
		return
	if Input.is_action_just_pressed('jump')\
		and not get_node("../TimerCoyoteJump").is_stopped():
		get_node("../TimerCoyoteJump").stop()
		machine.set_state("StateJumping")
		return
	if Input.is_action_just_pressed('jump'):
		get_node("../TimerBufferJump").start()
	if Input.is_action_pressed('jump'):
		machine.set_state("StateGliding")
		return
		
		
		
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
