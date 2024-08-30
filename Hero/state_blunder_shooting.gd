extends HeroState

var water_prone: bool = true
var death_prone: bool = true

var blunder_vel: Vector2
var blunder_dur: float

func on_enter():
	$"../../BlurFX".generating_copies = true

	if hero.is_on_floor():
		blunder_vel = hero.BLUNDER_GROUNDED_VELOCITY
		blunder_dur = hero.BLUNDER_GROUNDED_DURATION
	else:
		blunder_vel = hero.BLUNDER_AIRBORNE_VELOCITY
		blunder_dur = hero.BLUNDER_AIRBORNE_DURATION

	timer_blunder_shoot_duration.set_wait_time(blunder_dur)
	hero.velocity.x = blunder_vel.x * hero.facing_direction
	hero.velocity.y = blunder_vel.y

	timer_blunder_shoot_duration.start()
	timer_blunder_jump_window.start()

	$"../../Gfx/AnimatedSprite2D".play("recoil")
	if hero.is_on_wall()\
	and hero.facing_direction == round(hero.get_wall_normal().x):
		$"../../Gfx/AnimatedSprite2D".frame = 1

	hero.blundershoot()

func on_process(_delta: float):
	if Input.is_action_just_pressed("jump")\
	and not timer_blunder_jump_window.is_stopped():
		machine.set_state("StateBlunderJumping")
		return

	if timer_blunder_shoot_duration.is_stopped()\
	and hero.is_on_floor():
		machine.set_state("StateIdle")
		return

	if timer_blunder_shoot_duration.is_stopped()\
	and not hero.is_on_floor():
		machine.set_state("StateFalling")
		return

	if hero.on_wall_value_just_changed\
	and hero.is_on_wall()\
	and hero.facing_direction == round(hero.get_wall_normal().x):
		$"../../Gfx/AnimatedSprite2D".frame = 1

func on_physics_process(_delta: float):
	if hero.is_in_water\
	and not hero.is_on_wall():
		PropManager.place_prop(Vector2(hero.global_position.x, hero.last_water_surface), &"splash")

	hero.move_and_slide()

func on_exit():
	$"../../BlurFX".generating_copies = false
	timer_blunder_shoot_cooldown.start()
	hero.velocity.x = hero.SPEED * -hero.facing_direction
