extends HeroState

var water_prone: bool = false
var death_prone: bool = true

var bounce_count: int = 0
var shoot_hold_time: float = 0.0

const INITIAL_SHOT_INTERVAL: float = 0.1
const SHOT_INTERVAL_DECREASE_RATE: float = 0.08
const MIN_SHOT_INTERVAL: float = 0.01

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("blunderjump")
	$"../../Shooter".position = Vector2(0, 0)

	hero.current_blunder_jump_angle = 0
	hero.velocity.y = hero.BLUNDER_JUMP_VELOCITY
	bounce_count = 0
	shoot_hold_time = 0.0
	timer_blunder_jump_window.stop()

func on_process(delta: float):
	if Input.is_action_pressed("shoot"):
		shoot_hold_time += delta
		if timer_between_blunder_jumping_shots.is_stopped():
			hero.shooter.shoot_ad_hoc(hero.regular_shot_speed, hero.current_blunder_jump_angle, true)
			var new_wait_time = max(MIN_SHOT_INTERVAL, INITIAL_SHOT_INTERVAL
			- (shoot_hold_time * SHOT_INTERVAL_DECREASE_RATE))
			timer_between_blunder_jumping_shots.set_wait_time(new_wait_time)
			timer_between_blunder_jumping_shots.start()
	else:
		shoot_hold_time = 0.0

	if Input.is_action_just_pressed("jump"):
		timer_super_bounce_window.start()
		timer_buffer_jump.start()

	if hero.is_on_floor():
		PropManager.place_prop(hero.global_position, &"dust_pound")
		machine.set_state("StateIdle")
		return

	if hero.is_on_wall()\
	and hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return
	
	if hero.is_pushing_wall()\
	and Input.is_action_just_pressed("jump"):
		machine.set_state("StateWallClimbing")
		return

	if hero.is_just_in_water:
		if Input.is_action_pressed("jump")\
		and not timer_super_bounce_window.is_stopped():
			var boost =  -50 * (mini(bounce_count, 5) + 1)
			hero.velocity.y = hero.BLUNDER_JUMP_WATER_BOUNCE_VELOCITY + boost
			bounce_count += 1
			PropManager.place_prop(Vector2(hero.global_position.x, hero.last_water_surface), &"splash", hero.last_water_color)
		else:
			machine.set_state("StateFloating")

	if hero.velocity.y < 0\
	and Input.is_action_just_released("jump"):
		hero.velocity.y *= 0.5

func on_physics_process(delta: float):
	hero.current_blunder_jump_angle += delta * 1080 * hero.facing_direction
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	hero.move_and_slide()

func on_exit():
	$"../../Shooter".return_to_og_pos()
	$"../../Gfx".rotation_degrees = 0
	hero.current_blunder_jump_angle = 0
