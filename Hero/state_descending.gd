extends HeroState

var water_prone: bool = false
var death_prone: bool = true

func on_process(_delta: float):
	if hero.velocity.y > -10\
	and not Utils.is_pushing_sides():
		$"../../Gfx/AnimatedSprite2D".play("water_idle")
	else:
		if not hero.is_pushing_wall():
			$"../../Gfx/AnimatedSprite2D".play("water_swim")
		else:
			$"../../Gfx/AnimatedSprite2D".play("water_idle")

	hero.step_shooting(false, true) # inverted: false, wet: true

	if not hero.is_in_water:
		hero.resize_collider_to_regular()
		machine.set_state("StateIdle")
		if hero.is_on_floor():
			hero.global_position.y -= hero.FLOAT_TO_IDLE_HEIGHT_COMPENSATION
		return

	if Input.is_action_just_pressed("jump"):
		timer_buffer_jump.start()
		
	if Input.is_action_just_pressed("jump")\
	and hero.is_head_above_water()\
	and hero.is_pushing_wall():
		hero.resize_collider_to_regular()
		machine.set_state("StateJumping")
		return

	if Input.is_action_pressed("jump")\
	and hero.global_position.y > hero.last_water_surface + 16: # Magic Number Alert
		machine.set_state("StateAscending")
		return 

func on_physics_process(delta: float):
	hero.step_grav(delta, hero.UNDERWATER_GRAVITY)
	hero.step_lateral_mov(delta)

	hero.velocity.y = minf(hero.velocity.y, hero.MAX_DESCENT_VEL_Y)
	
	if hero.velocity.y < 0\
	and hero.global_position.y - hero.last_water_surface < 32: # Magic Number Alert
		hero.velocity.y = 0
	
	hero.step_repel_swim_feet(delta)
	
	hero.move_and_slide()
