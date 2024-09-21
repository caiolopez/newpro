extends HeroState

var water_prone: bool = false
var death_prone: bool = true

func on_enter():
	hero.resize_collider_to_swim()
	if not machine.last_state.name == "StateWetBlunderShooting":
		PropManager.place_prop(Vector2(hero.global_position.x, hero.last_water_surface), &"splash", hero.last_water_color)

func on_process(_delta: float):
	if Utils.is_pushing_sides():
		$"../../Gfx/AnimatedSprite2D".play("water_swim")
	else:
		$"../../Gfx/AnimatedSprite2D".play("water_idle")

	hero.step_shooting(false, true) # inverted: false, wet: true

	if not hero.is_in_water:
		machine.set_state("StateIdle")
		return

	if hero.can_dive:
		machine.set_state("StateDescending")
		return

	if Input.is_action_just_pressed("jump"):
		timer_buffer_jump.start()

	if not timer_buffer_jump.is_stopped()\
	and hero.is_pushing_wall()\
	and hero.is_head_above_water():
		machine.set_state("StateJumping")
		return

	if Input.is_action_just_pressed("jump")\
	and hero.is_on_floor():
		machine.set_state("StateJumping")
		return

	if Input.is_action_just_pressed("jump")\
	and hero.is_pushing_wall()\
	and hero.is_head_above_water():
		machine.set_state("StateJumping")
		return

func on_physics_process(delta: float):
	if not hero.can_dive:
		hero.velocity.y = (hero.velocity.y - (hero.BUOYANCY * (hero.global_position.y - (hero.last_water_surface))*delta - 64))*pow(0.80, 1-delta)

	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	hero.step_repel_swim_feet(delta)

	hero.move_and_slide()
