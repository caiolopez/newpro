extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_on_floor(): machine.set_state("StateIdle")
	if not Input.is_action_pressed('jump'): machine.set_state("StateFalling")
	
	if Input.is_action_pressed('jump'): hero.velocity.y = hero.GLIDE_VELOCITY
	
	hero.step_lateral_mov(delta)
	
	
	hero.move_and_slide()


func on_exit():
	pass
