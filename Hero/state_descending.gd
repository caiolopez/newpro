extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	pass

func on_process(_delta: float):
	if hero.velocity.y > -10\
	and not Utils.is_pushing_sides():
		$"../../Gfx/AnimatedSprite2D".play("water_idle")
	else:
		$"../../Gfx/AnimatedSprite2D".play("water_swim")

	hero.step_shooting(false, true) # inverted: false, wet: true

	if not hero.is_in_water:
		machine.set_state("StateIdle")
		return

	if Input.is_action_just_pressed("jump")\
	and hero.is_head_above_water()\
	and hero.is_pushing_wall():
		machine.set_state("StateJumping")
		return

	if hero.is_on_floor():
		machine.set_state("StateOnSeaFloor")
		return

	if Input.is_action_just_pressed("jump")\
	and hero.is_head_above_water()\
	and hero.is_on_floor():
		machine.set_state("StateJumping")
		return

	if Input.is_action_just_pressed("jump"):
		timer_buffer_jump.start()

	if Input.is_action_pressed("jump")\
	and hero.global_position.y > hero.last_water_surface + 64:
		machine.set_state("StateAscending")
		return


func on_physics_process(delta: float):
	hero.step_grav(delta, hero.UNDERWATER_GRAVITY)
	hero.step_lateral_mov(delta)

	hero.velocity.y = minf(hero.velocity.y, hero.MAX_DESCENT_VEL_Y)
	
	if hero.velocity.y < 0\
	and hero.global_position.y < hero.last_water_surface + 64:
		hero.velocity.y = 0
	
	if hero.pelvis_back_rc.is_colliding():
		hero.repel_ass(delta)
	
	hero.move_and_slide()


func on_exit():
	pass
