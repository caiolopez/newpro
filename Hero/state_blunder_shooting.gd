extends HeroState

func on_enter():
	if hero.is_on_floor():
		get_node("../TimerBlunderShootDuration").set_wait_time(hero.BLUNDER_GROUNDED_DURATION)
		hero.velocity.x = hero.BLUNDER_GROUNDED_VELOCITY.x*hero.facing_direction
		hero.velocity.y = hero.BLUNDER_GROUNDED_VELOCITY.y
	else:
		get_node("../TimerBlunderShootDuration").set_wait_time(hero.BLUNDER_AIRBORNE_DURATION)
		hero.velocity.x = hero.BLUNDER_AIRBORNE_VELOCITY.x*hero.facing_direction
		hero.velocity.y = hero.BLUNDER_AIRBORNE_VELOCITY.y
	get_node("../TimerBlunderShootDuration").start()
	get_node("../TimerBlunderShootCooldown").start()
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if get_node("../TimerBlunderShootDuration").is_stopped():
		machine.set_state("StateIdle")
		return
	
	

	hero.move_and_slide()


func on_exit():
	pass
