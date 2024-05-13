extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	pass

func on_physics_process(delta: float):
	if not hero.is_on_water:
		machine.set_state("StateIdle")
		return
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateWetBlunderShooting")
		return
	if not Input.is_action_pressed('jump'):
		machine.set_state("StateDescending")
		return
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()
	
	if hero.global_position.y > hero.last_water_surface + 32:
		hero.velocity.y = hero.ASCENDING_VELOCITY
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
