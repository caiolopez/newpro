extends HeroState

func on_enter():
	get_node("../TimerBlunderShootDuration").set_wait_time(hero.BLUNDER_GROUNDED_DURATION)
	hero.velocity.x = hero.BLUNDER_GROUNDED_VELOCITY.x*hero.facing_direction
	hero.velocity.y = hero.BLUNDER_GROUNDED_VELOCITY.y
	get_node("../TimerBlunderShootDuration").start()
	hero.shoot_blunder(4,45)

func on_process(delta: float):
	if Input.is_action_just_pressed('jump')\
	or get_node("../TimerBlunderShootDuration").is_stopped():
		machine.set_state("StateFloating")
		return

		
func on_physics_process(delta: float):

	

	hero.move_and_slide()


func on_exit():
	get_node("../TimerBlunderShootCooldown").start()
