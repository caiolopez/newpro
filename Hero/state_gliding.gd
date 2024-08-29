extends HeroState

var water_prone: bool = true
var death_prone: bool = true

func on_enter():
	$"../../Gfx/ParachuteAnim".show()
	$"../../Gfx/ParachuteAnim".play("deploy_parachute")
	$"../../Gfx/AnimatedSprite2D".play("glide_in")
	
	if (hero.is_on_wall() or not timer_leaving_wall.is_stopped())\
	and Input.is_action_just_pressed('jump'):
		timer_coyote_wall.start()
		if DebugTools.print_stuff: print('COYOTE STARTED')

	if not hero.is_on_wall() and Input.is_action_just_pressed('jump'):
		timer_buffer_climbing.start()
		

func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shoot()

	if hero.on_wall_value_just_changed\
	and not hero.is_on_wall():
		timer_leaving_wall.start()
		print("LEAVINGN WALL FROM GLIDE")

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return

	if not timer_coyote_wall.is_stopped()\
	and hero.is_pushing_wall():
			timer_coyote_wall.stop()
			machine.set_state("StateWallClimbing")
			if DebugTools.print_stuff: print('COYOTE WALLCLIMB')
			return

	if not Input.is_action_pressed("jump"):
		machine.set_state("StateFalling")
		return

	if hero.is_pushing_wall()\
	and not timer_buffer_climbing.is_stopped():
		timer_buffer_climbing.stop()
		machine.set_state("StateWallClimbing")
		if DebugTools.print_stuff: print("ASSISTED")
		return

	if hero.is_pushing_wall()\
	and hero.pelvis_rc.is_colliding()\
	and hero.shoulder_rc.is_colliding():
		machine.set_state("StateWallGrabbing")
		return

func on_physics_process(delta: float):
	
	if Input.is_action_pressed("jump")\
	and timer_before_glide.is_stopped():
		hero.velocity.y -= 25000 * delta
		hero.velocity.y = maxf(hero.velocity.y, hero.GLIDE_VELOCITY)
	else:
		hero.step_grav(delta)
	
	hero.step_lateral_mov(delta)
	hero.step_walljump()
	
	hero.move_and_slide()


func on_exit():
	if $"../../Gfx/ParachuteAnim".get_frame() > 9:
		$"../../Gfx/ParachuteAnim".play("hide_parachute")
	else:
		$"../../Gfx/ParachuteAnim".hide()
