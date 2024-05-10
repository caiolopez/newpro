extends HeroState

func on_enter():
	hero.velocity.y = hero.BLUNDER_JUMP_VELOCITY
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_on_floor(): machine.set_state("StateIdle")
	if hero.is_on_wall(): machine.set_state("StateFalling")
	
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
