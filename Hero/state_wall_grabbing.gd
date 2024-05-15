extends HeroState

func on_enter():
	hero.velocity.y = 0

func on_process(delta: float):
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
	if not hero.is_pushing_wall():
		machine.set_state("StateGliding")
		return
	if Input.is_action_just_released('jump'):
		machine.set_state("StateFalling")
		return
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

		
func on_physics_process(delta: float):

	hero.step_lateral_mov(delta)
	
	
	hero.move_and_slide()


func on_exit():
	pass
