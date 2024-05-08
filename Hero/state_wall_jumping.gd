extends HeroState

func on_enter():
	get_node("../TimerBufferJump").stop()
	hero.velocity.x = hero.WALLJUMP_VELOCITY.x * round(hero.get_wall_normal().x)
	hero.velocity.y = hero.WALLJUMP_VELOCITY.y

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if not hero.is_on_floor() and hero.velocity.y > 0: machine.set_state("StateFalling")


	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
