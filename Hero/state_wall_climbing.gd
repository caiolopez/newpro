extends HeroState

func on_enter():
	hero.velocity.y = hero.CLIMB_VELOCITY

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_on_floor(): machine.set_state("StateIdle")
	if hero.velocity.y > 0 and not hero.is_on_floor(): machine.set_state("StateFalling")
	
	
	
	if Input.is_action_just_pressed('jump') and hero.is_pushing_wall(): hero.velocity.y = hero.CLIMB_VELOCITY
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	hero.move_and_slide()


func on_exit():
	pass
