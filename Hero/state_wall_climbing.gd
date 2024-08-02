extends HeroState

var water_prone: bool = true
var death_prone: bool = true

var can_wj: bool

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("wallclimb_w_guns")

	hero.velocity.y = hero.CLIMB_VELOCITY
	can_wj = false

func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
	and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shoot()

	if Input.is_action_just_pressed('jump'):
		if hero.is_pushing_wall():
			$"../../Gfx/AnimatedSprite2D".frame = 0
			$"../../Gfx/AnimatedSprite2D".play("wallclimb_w_guns")
			hero.velocity.y = hero.CLIMB_VELOCITY
			can_wj = false
			return
		else:
			timer_climb_to_glide_wall_jump.start()
	
	if Input.is_action_just_released('jump'): can_wj = true
	
	if hero.velocity.y < 0\
	and not hero.pelvis_rc.is_colliding()\
	and not hero.shoulder_rc.is_colliding()\
	and hero.next_grd_height.is_colliding()\
	and hero.is_pushing_wall():
		machine.set_state("StateVaulting")
		return

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return

	if hero.is_move_dir_away_from_last_wall()\
	and not hero.is_on_wall()\
	and Input.is_action_just_pressed('jump'):
		timer_leaving_wall.stop()
		machine.set_state("StateWallJumping")
		print("mode 1")
		return

	if hero.is_move_dir_away_from_last_wall()\
	and can_wj\
	and Input.is_action_pressed('jump'):
		timer_leaving_wall.stop()
		machine.set_state("StateWallJumping")
		print("mode 2")
		return

	if hero.velocity.y > 0\
	and not hero.is_on_floor():
		if hero.is_move_dir_away_from_last_wall():
			timer_climb_to_fall_wall_jump.start()
		machine.set_state("StateFalling")
		return
		
	if Input.is_action_just_released('jump'):
		hero.velocity.y *= 0.5

	if not hero.is_on_wall():
		$"../../Gfx/AnimatedSprite2D".play("vault")

func on_physics_process(delta: float):
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	hero.move_and_slide()
