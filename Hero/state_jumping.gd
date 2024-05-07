extends HeroState

func on_enter():
	hero.velocity.y = hero.JUMP_VELOCITY

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.velocity.y > 0: machine.set_state("StateFalling")
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	if Input.is_action_just_released('jump'): hero.velocity.y = 0
	
	hero.move_and_slide()


func on_exit():
	pass
