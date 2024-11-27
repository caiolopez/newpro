extends HeroState

var water_prone: bool = true
var death_prone: bool = true

func on_enter():
	hero.resize_collider_to_airborne()
	$"../../Gfx/AnimatedSprite2D".play("wallclimb")
	AudioManager.hooks.hero_wall_climb_sfx()
	hero.velocity.y = hero.CLIMB_VELOCITY

func on_process(_delta: float):
	if hero.step_shooting():
		return

	if Input.is_action_just_pressed("jump"):
		if hero.is_pushing_wall():
			$"../../Gfx/AnimatedSprite2D".frame = 0
			$"../../Gfx/AnimatedSprite2D".play("wallclimb")
			AudioManager.hooks.hero_wall_climb_sfx()
			hero.velocity.y = hero.CLIMB_VELOCITY
			return

	if hero.velocity.y < 0\
	and not hero.pelvis_rc.is_colliding()\
	and not hero.shoulder_rc.is_colliding(): 
		if hero.next_grd_height_rc.is_colliding():
			machine.set_state("StateVaulting")
		elif not hero.is_pushing_wall():
			machine.set_state("StateFalling")
		return

	if hero.velocity.y > 0:
		machine.set_state("StateFalling")

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return

	if Input.is_action_just_released("jump"):
		hero.velocity.y *= 0.5

func on_physics_process(delta: float):
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	hero.move_and_slide()

func on_exit():
	hero.resize_collider_to_regular()
