extends HeroState

var water_prone: bool = true
var death_prone: bool = true

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("walljump")
	
	PropManager.place_prop(Vector2(
		hero.global_position.x - 64 * hero.facing_direction,
		hero.global_position.y), &"dust_jump")

	timer_walljump_duration.start()
	hero.velocity.x = hero.WALLJUMP_VELOCITY.x * hero.facing_direction
	hero.velocity.y = hero.WALLJUMP_VELOCITY.y

func on_process(_delta: float):
	if hero.step_shooting():
		return

	if not hero.is_on_floor() and hero.velocity.y > 0:
		timer_walljump_duration.stop()
		machine.set_state("StateFalling")
		return

	if Input.is_action_just_released("jump"):
		timer_walljump_duration.stop()
		machine.set_state("StateFalling")
		return

	if hero.velocity.y < 0\
	and hero.is_pushing_wall()\
	and not hero.shoulder_rc.is_colliding()\
	and not hero.pelvis_rc.is_colliding()\
	and hero.next_grd_height_rc.is_colliding():
		machine.set_state("StateVaulting")

func on_physics_process(delta: float):
	hero.step_grav(delta)
	if timer_walljump_duration.is_stopped():
		hero.step_lateral_mov(delta)
	hero.move_and_slide()
