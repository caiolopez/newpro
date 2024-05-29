extends HeroState

var water_prone: bool = true
var death_prone: bool = true

func on_enter():
	if (hero.is_on_wall() or not timer_leaving_wall.is_stopped())\
	and Input.is_action_just_pressed('jump'):
		timer_coyote_wall.start()
		print('COYOTE STARTED')
	if not hero.is_on_wall() and Input.is_action_just_pressed('jump'):
		timer_buffer_wall_jump.start()
		

func on_process(delta: float):
	
	if hero.on_wall_value_just_changed\
	and not hero.is_on_wall():
		timer_leaving_wall.start()
		
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
	if not timer_coyote_wall.is_stopped():
		if hero.is_move_dir_away_from_last_wall(false):
			timer_coyote_wall.stop()
			machine.set_state("StateWallJumping")
			print('COYOTE WALLJUMP')
			return
		elif hero.is_pushing_wall():
			timer_coyote_wall.stop()
			machine.set_state("StateWallClimbing")
			print('COYOTE WALLCLIMB')
			return
	if not Input.is_action_pressed("jump"):
		machine.set_state("StateFalling")
		return
	if hero.is_pushing_wall()\
		and not timer_buffer_wall_jump.is_stopped():
		timer_buffer_wall_jump.stop()
		machine.set_state("StateWallClimbing")
		print("BUFFERED WALLJUMP")
		return
	if hero.is_pushing_wall()\
	and hero.pelvis_rc.is_colliding()\
	and hero.shoulder_rc.is_colliding():
		machine.set_state("StateWallGrabbing")
		return
		
	if hero.is_move_dir_away_from_last_wall(true)\
	and not timer_climb_to_glide_wall_jump.is_stopped()\
	and Input.is_action_pressed("jump"):
			machine.set_state("StateWallJumping")
			print('MODE 3')
			return

	if Input.is_action_just_pressed("jump"):
		hero.velocity.y = hero.GLIDE_VELOCITY/2
		
	if Input.is_action_just_pressed("shoot"):
		hero.shooter.shoot_ad_hoc(hero.regular_shot_speed)

		
func on_physics_process(delta: float):
	
	if Input.is_action_pressed("jump"):
		hero.velocity.y -= 2500 * delta
		hero.velocity.y = maxf(hero.velocity.y, hero.GLIDE_VELOCITY)
	
	hero.step_lateral_mov(delta)
	
	
	hero.move_and_slide()


func on_exit():
	pass
