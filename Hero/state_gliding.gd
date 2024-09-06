extends HeroState

var water_prone: bool = true
var death_prone: bool = true

func on_enter():
	$"../../Gfx/ParachuteAnim".show()
	$"../../Gfx/ParachuteAnim".play("deploy_parachute")
	$"../../Gfx/AnimatedSprite2D".play("glide")

	if not hero.is_on_wall() and Input.is_action_just_pressed("jump"):
		timer_buffer_climbing.start()

func on_process(_delta: float):
	if hero.step_shooting():
		return

	if hero.is_on_floor():
		machine.set_state("StateIdle")
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
	and hero.shoulder_rc.is_colliding()\
	and abs(hero.get_wall_normal().x) > 0.99:
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
