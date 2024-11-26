extends HeroState

var water_prone: bool = false
var death_prone: bool = true

func on_enter():
	hero.resize_collider_to_airborne()
	AudioManager.hooks.hero_jump_sfx()
	$"../../Gfx/AnimatedSprite2D".play("jump")
	PropManager.place_prop(hero.global_position, &"dust_jump")
	hero.velocity.y = hero.JUMP_VELOCITY

func on_process(_delta: float):
	if hero.just_left_water:
		PropManager.place_prop(Vector2(hero.global_position.x, hero.last_water_surface), &"splash", hero.last_water_color)

	if hero.step_shooting():
		return

	if Input.is_action_just_pressed("jump"):
		timer_buffer_walljump.start()

	hero.step_walljump()

	if not hero.is_on_wall()\
	and Input.is_action_just_pressed("jump"):
		timer_buffer_climbing.start()

	if hero.is_just_on_floor\
	and not hero.is_in_water:
		machine.set_state("StateIdle")
		return

	if Input.is_action_just_pressed("jump")\
	and hero.is_pushing_wall()\
	and not hero.is_pushing_overhanging_wall():
		machine.set_state("StateWallClimbing")
		return

	if hero.velocity.y >= 0:
		machine.set_state("StateFalling")
		return

	if absf(hero.velocity.y) < 200\
	and hero.is_pushing_wall()\
	and not hero.shoulder_rc.is_colliding()\
	and not hero.pelvis_rc.is_colliding()\
	and hero.next_grd_height_rc.is_colliding():
		machine.set_state("StateVaulting")

	if hero.is_pushing_wall()\
	and not hero.is_pushing_overhanging_wall()\
	and not timer_buffer_climbing.is_stopped():
		timer_buffer_climbing.stop()
		machine.set_state("StateWallClimbing")
		if DebugTools.print_stuff: print("ASSISTED")
		return

func on_physics_process(delta: float):
	if  hero.headbutt_assist_rc.is_colliding()\
	and hero.velocity.y < hero.HEADBUTT_THRESHOLD_VEL:
		hero.global_position.x = hero.headbutt_assist_rc.get_collision_point().x + (%HeroCollider.shape.get_rect().size.x/2 + 1) * hero.facing_direction
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	if Input.is_action_just_released("jump"): hero.velocity.y *= 0.25
	
	hero.move_and_slide()

func on_exit():
	hero.resize_collider_to_regular()
