extends HeroState

func on_enter():
	hero.velocity.y = hero.CLIMB_VELOCITY

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
	if hero.velocity.y > 0 and not hero.is_on_floor():
		machine.set_state("StateFalling")
		return
	if hero.is_move_dir_away_from_last_wall(false) and Input.is_action_pressed('jump'):
		machine.set_state("StateWallJumping")
		return
		
	
	
	
	if Input.is_action_just_pressed('jump') and hero.is_pushing_wall(): hero.velocity.y = hero.CLIMB_VELOCITY
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	hero.move_and_slide()


func on_exit():
	pass
