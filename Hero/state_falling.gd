extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_on_floor(): machine.set_state("StateIdle")
	if Input.is_action_just_pressed('jump') and hero.is_pushing_wall():
		machine.set_state("StateWallClimbing")
		return
	if Input.is_action_just_pressed('jump') and not get_node("../TimerCoyoteJump").is_stopped():
		hero.velocity.y = hero.JUMP_VELOCITY
		machine.set_state("StateJumping")
		return
	if Input.is_action_pressed('jump'): machine.set_state("StateGliding")
	
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
