extends HeroState

func on_enter():
	hero.velocity.y = hero.JUMP_VELOCITY

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.velocity.y > 0: machine.set_state("StateFalling")
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	if Input.is_action_just_released('jump'): hero.velocity.y = 0
	
	hero.move_and_slide()


func on_exit():
	pass
