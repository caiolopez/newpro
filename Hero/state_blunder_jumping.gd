extends HeroState

var water_prone = false
var death_prone = true

var current_bounce_vel: float

func on_enter():
	hero.velocity.y = hero.BLUNDER_JUMP_VELOCITY
	current_bounce_vel = hero.BLUNDER_JUMP_WATER_BOUNCE_VELOCITY
	timer_blunder_jump_window.stop()

func on_process(delta: float):
	if Input.is_action_just_pressed('jump'):
		timer_super_bounce_window.start()
	if hero.is_on_floor(): machine.set_state("StateIdle")
	if hero.is_on_wall(): machine.set_state("StateFalling")
	if hero.is_just_on_water:
		if Input.is_action_pressed('jump')\
		and current_bounce_vel < hero.BLUNDER_JUMP_WATER_BOUNCE_VELOCITY/2:
			if not timer_super_bounce_window.is_stopped():
				hero.velocity.y = hero.BLUNDER_JUMP_WATER_BOUNCE_VELOCITY*1.5
				current_bounce_vel = hero.BLUNDER_JUMP_WATER_BOUNCE_VELOCITY
			else:
				hero.velocity.y = current_bounce_vel
				current_bounce_vel *= 0.8
		else:
			machine.set_state("StateFloating")

	if hero.velocity.y < 0\
	and Input.is_action_just_released('jump'):
		hero.velocity.y *= 0.5


func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
