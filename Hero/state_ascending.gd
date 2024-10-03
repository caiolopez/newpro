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
		hero.resize_collider_to_regular()
		machine.set_state("StateIdle")
		if hero.is_on_floor():
			hero.global_position.y -= hero.FLOAT_TO_IDLE_HEIGHT_COMPENSATION
		return

	if not Input.is_action_pressed("jump"):
		machine.set_state("StateDescending")

func on_physics_process(delta: float):
	if hero.global_position.y - hero.last_water_surface > 36: # Magic Number Alert
		hero.velocity.y = hero.ASCENDING_VELOCITY
	else:
		hero.global_position.y = hero.last_water_surface + 34 # Magic Number Alert
		hero.velocity.y = 0
	hero.step_lateral_mov(delta)
	hero.step_repel_swim_feet(delta)
	hero.move_and_slide()
