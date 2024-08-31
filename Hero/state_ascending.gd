extends HeroState

var water_prone: bool = false
var death_prone: bool = true

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("water_swim")

func on_process(_delta: float):
	hero.step_shooting(false, true) # inverted: false, wet: true

	if not timer_buffer_jump.is_stopped()\
	and hero.is_pushing_wall()\
	and hero.is_head_above_water():
		machine.set_state("StateJumping")
		return

	if not hero.is_in_water:
		machine.set_state("StateIdle")
		return

	if not Input.is_action_pressed("jump"):
		machine.set_state("StateDescending")


func on_physics_process(delta: float):
	if hero.global_position.y > hero.last_water_surface + 64:
		hero.velocity.y = hero.ASCENDING_VELOCITY
	else:
		hero.velocity.y = 0

	hero.step_lateral_mov(delta)
	
	if hero.pelvis_back_rc.is_colliding():
		hero.repel_ass(delta)

	hero.move_and_slide()

func on_exit():
	pass
