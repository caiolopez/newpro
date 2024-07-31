extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	pass

func on_process(_delta: float):
	if Input.is_action_pressed("move_left")\
		or Input.is_action_pressed("move_right"):
		$"../../Gfx/AnimatedSprite2D".play("ascend_h")
	else:
		$"../../Gfx/AnimatedSprite2D".play("ascend_v")
	
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateWetBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shoot()

	if not hero.is_in_water:
		machine.set_state("StateIdle")
		return

	if not Input.is_action_pressed('jump'):
		machine.set_state("StateDescending")


func on_physics_process(delta: float):

	
	if hero.global_position.y > hero.last_water_surface + 16:
		hero.velocity.y = hero.ASCENDING_VELOCITY
	else:
		hero.velocity.y = hero.ASCENDING_VELOCITY * (hero.global_position.y - hero.last_water_surface)*delta
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
