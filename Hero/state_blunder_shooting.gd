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
	get_node("../TimerBlunderJumpWindow").start()
	hero.shoot_blunder(4,45)

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if Input.is_action_just_pressed('jump')\
		and not get_node("../TimerBlunderJumpWindow").is_stopped():
		machine.set_state("StateBlunderJumping")
		return
	if get_node("../TimerBlunderShootDuration").is_stopped()\
		and hero.is_on_floor():
		machine.set_state("StateIdle")
		return
	if get_node("../TimerBlunderShootDuration").is_stopped()\
		and not hero.is_on_floor():
		machine.set_state("StateFalling")
		return
	
	

	hero.move_and_slide()


func on_exit():
	pass
