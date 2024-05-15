extends HeroState

func on_enter():
	if (hero.is_on_wall() or not get_node("../TimerLeavingWall").is_stopped())\
	and Input.is_action_just_pressed('jump'):
		get_node("../TimerCoyoteWallJump").start()
		print('COYOTE START ______________________________')
	if not hero.is_on_wall() and Input.is_action_just_pressed('jump'):
		get_node("../TimerBufferWallJump").start()
		

func on_process(delta: float):
	if hero.is_on_wall_value_change()\
	and not hero.is_on_wall():
		get_node("../TimerLeavingWall").start()
		print('LEFT WALL - GLIDING')
		
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
	and not get_node("../TimerCoyoteWallJump").is_stopped():
		get_node("../TimerCoyoteWallJump").stop()
		machine.set_state("StateWallJumping")
		print('COYOTE START ______________________________')
		return


	if Input.is_action_pressed("jump"): hero.velocity.y = hero.GLIDE_VELOCITY
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

		
func on_physics_process(delta: float):

	
	hero.step_lateral_mov(delta)
	
	
	hero.move_and_slide()


func on_exit():
	pass
