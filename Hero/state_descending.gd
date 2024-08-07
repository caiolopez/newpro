extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("water_idle")
	pass

func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
	and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateWetBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shoot()

	if not hero.is_in_water:
		machine.set_state("StateIdle")
		return

	if Input.is_action_just_pressed('jump')\
	and hero.is_head_above_water()\
	and hero.is_pushing_wall():
		machine.set_state("StateJumping")
		return

	if Input.is_action_just_pressed('jump')\
	and hero.is_head_above_water()\
	and hero.is_on_floor():
		machine.set_state("StateJumping")
		return

	if Input.is_action_pressed("jump"):
		machine.set_state("StateAscending")
		return


func on_physics_process(delta: float):
	hero.step_grav(delta, hero.UNDERWATER_GRAVITY)
	hero.step_lateral_mov(delta)

	hero.velocity.y = minf(hero.velocity.y, hero.MAX_DESCENT_VEL_Y)

	hero.move_and_slide()


func on_exit():
	pass
