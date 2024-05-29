extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	pass

func on_process(delta: float):
	if not hero.is_on_water:
		machine.set_state("StateIdle")
		return
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateWetBlunderShooting")
		return
	if not Input.is_action_pressed('jump'):
		machine.set_state("StateDescending")
		return
	
	if Input.is_action_just_pressed("shoot"):
		hero.shooter.shoot_ad_hoc(hero.regular_shot_speed)

func on_physics_process(delta: float):

	
	if hero.global_position.y > hero.last_water_surface + 16:
		hero.velocity.y = hero.ASCENDING_VELOCITY
	else:
		hero.velocity.y = hero.ASCENDING_VELOCITY * (hero.global_position.y - hero.last_water_surface)*delta
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
