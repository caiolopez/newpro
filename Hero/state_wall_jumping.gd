extends HeroState

var water_prone: bool = true
var death_prone: bool = true


func on_enter():
	timer_wall_jump_duration.start()
	hero.velocity.x = hero.WALLJUMP_VELOCITY.x * round(hero.get_wall_normal().x)
	hero.velocity.y = hero.WALLJUMP_VELOCITY.y
	hero.facing_direction = round(hero.get_wall_normal().x)

func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shooter.shoot_ad_hoc(hero.regular_shot_speed)

	if not hero.is_on_floor() and hero.velocity.y > 0:
		timer_wall_jump_duration.stop()
		machine.set_state("StateFalling")
		return

	if Input.is_action_just_released("jump"):
		timer_wall_jump_duration.stop()
		machine.set_state("StateFalling")
		return


func on_physics_process(delta: float):
	hero.step_grav(delta)
	if timer_wall_jump_duration.is_stopped():
		hero.step_lateral_mov(delta)
	hero.move_and_slide()


func on_exit():
	pass
