extends HeroState

var water_prone = false
var death_prone = true


func on_enter():
	hero.velocity.y = hero.JUMP_VELOCITY

func on_process(delta: float):
	if hero.is_just_on_floor:
		machine.set_state("StateIdle")
		return
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.velocity.y > 0: machine.set_state("StateFalling")
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

		
func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	if Input.is_action_just_released('jump'): hero.velocity.y *= 0.25
	
	hero.move_and_slide()


func on_exit():
	pass
