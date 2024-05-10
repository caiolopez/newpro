extends HeroState

func on_enter():
	get_node("../TimerWallJumpDuration").start()
	hero.velocity.x = hero.WALLJUMP_VELOCITY.x * round(hero.get_wall_normal().x)
	hero.velocity.y = hero.WALLJUMP_VELOCITY.y
	hero.facing_direction = round(hero.get_wall_normal().x)

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_input_blunder_shoot()\
		and get_node("../TimerBlunderShootCooldown").is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if not hero.is_on_floor() and hero.velocity.y > 0:
		get_node("../TimerWallJumpDuration").stop()
		machine.set_state("StateFalling")
		return
	if Input.is_action_just_released("jump"):
		get_node("../TimerWallJumpDuration").stop()
		machine.set_state("StateFalling")
		return


	hero.step_grav(delta)
	if get_node("../TimerWallJumpDuration").is_stopped():
		hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
