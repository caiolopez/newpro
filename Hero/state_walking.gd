extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.is_on_floor() and hero.velocity.x == 0: machine.set_state("StateIdle")
	if not hero.is_on_floor() and hero.velocity.y > 0:
		get_node("../TimerCoyoteJump").start()
		machine.set_state("StateFalling")
		return
	if Input.is_action_just_pressed('jump'): machine.set_state("StateJumping")

	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
