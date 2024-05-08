extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
	if not hero.is_pushing_wall():
		machine.set_state("StateGliding")
		return
	if Input.is_action_just_released('jump'):
		machine.set_state("StateFalling")
		return
	
	hero.velocity.y = 0
	hero.step_lateral_mov(delta)
	
	
	hero.move_and_slide()


func on_exit():
	pass
