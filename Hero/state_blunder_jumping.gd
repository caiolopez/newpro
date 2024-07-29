extends HeroState

var water_prone: bool = false
var death_prone: bool = true
var current_bounce_vel: float

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("blunderjump")
	$"../../Shooter".position = Vector2(0, 0)
	
	hero.current_blunder_jump_angle = 0
	hero.velocity.y = hero.BLUNDER_JUMP_VELOCITY
	current_bounce_vel = hero.BLUNDER_JUMP_WATER_BOUNCE_VELOCITY
	timer_blunder_jump_window.stop()

func on_process(_delta: float):
	if Input.is_action_pressed("shoot")\
	and timer_between_blunder_jumping_shots.is_stopped():
		hero.shooter.shoot_ad_hoc(hero.regular_shot_speed, hero.current_blunder_jump_angle, true)
		timer_between_blunder_jumping_shots.start()
		
		
	if Input.is_action_just_pressed('jump'):
		timer_super_bounce_window.start()

	if hero.is_on_floor():
		
		var dust = load("res://Props/DustAnimProp.tscn").instantiate()
		dust.global_position = hero.global_position
		get_node("/root/GameTree").add_child(dust)
		
		machine.set_state("StateIdle")
		return

	if hero.is_on_wall()\
	and hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return
	
	if hero.is_pushing_wall()\
	and Input.is_action_just_pressed('jump'):
		machine.set_state("StateWallClimbing")
		return

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
	hero.current_blunder_jump_angle += delta * 1080 * hero.facing_direction
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	hero.move_and_slide()


func on_exit():
	$"../../Shooter".return_to_og_pos()
	$"../../Gfx".rotation_degrees = 0
	hero.current_blunder_jump_angle = 0
