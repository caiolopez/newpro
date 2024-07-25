extends HeroState

var water_prone: bool = true
var death_prone: bool = true


func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("walk")
	pass

func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shoot()

	hero.step_auto_snap()

	if Input.is_action_just_pressed('jump'):
		machine.set_state("StateJumping")
		return

	if hero.is_on_floor() and hero.velocity.x == 0:
		machine.set_state("StateIdle")
		return

	if not hero.is_on_floor() and hero.velocity.y > 0:
		timer_coyote_jump.start()
		machine.set_state("StateFalling")
		return


func on_physics_process(delta: float):
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	hero.move_and_slide()


func on_exit():
	pass
