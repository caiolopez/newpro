extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.velocity.x != 0: machine.set_state("StateWalking")
	if not hero.is_on_floor() and hero.velocity.y > 0: machine.set_state("StateFalling")
	if Input.is_action_just_pressed('jump'): machine.set_state("StateJumping")
	if Input.is_action_pressed('jump') and not get_node("../TimerBufferJump").is_stopped():
		get_node("../TimerBufferJump").stop()
		machine.set_state("StateJumping")
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
