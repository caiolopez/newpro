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
	
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.velocity.y = minf(hero.velocity.y, hero.MAX_DESCENT_VEL_Y)

	hero.move_and_slide()


func on_exit():
	pass
