extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.velocity.x != 0: machine.set_state("StateWalking")
	if not hero.is_on_floor() and hero.velocity.y > 0: machine.set_state("StateFalling")
	if not hero.is_on_floor() and hero.velocity.y < 0: machine.set_state("StateJumping")

	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	if Input.is_action_just_pressed('jump'): hero.velocity.y = hero.JUMP_VELOCITY
	if Input.is_action_just_released('jump'): hero.velocity.y = 0

	hero.move_and_slide()


func on_exit():
	pass
