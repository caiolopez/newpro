extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("water_swim")

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

	if not Input.is_action_pressed('jump'):
		machine.set_state("StateDescending")


func on_physics_process(delta: float):
	if hero.global_position.y > hero.last_water_surface + 64:
		hero.velocity.y = hero.ASCENDING_VELOCITY
	else:
		hero.velocity.y = 0

	hero.step_lateral_mov(delta)
	
	if hero.ass_rc.is_colliding():
		hero.repel_ass(delta)

	hero.move_and_slide()


func on_exit():
	pass
