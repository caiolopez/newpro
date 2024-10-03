extends HeroState

var water_prone: bool = false
var death_prone: bool = true

const BUOYANCY_OFFSET = 16 # Use this to fine-tune the depth hero will be floating at.
const WATER_DAMPING_FACTOR = 0.80 # Mystery magic number.

func on_enter():
	hero.resize_collider_to_swim()
	if not machine.last_state.name == "StateWetBlunderShooting":
		PropManager.place_prop(Vector2(hero.global_position.x, hero.last_water_surface), &"splash", hero.last_water_color)

func on_process(_delta: float):
	if Utils.is_pushing_sides()\
	and not hero.is_pushing_wall():
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
		hero.velocity.y = (hero.velocity.y - (hero.BUOYANCY * (hero.global_position.y - (hero.last_water_surface))*delta - BUOYANCY_OFFSET)) * pow(WATER_DAMPING_FACTOR, 1-delta)

	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	hero.step_repel_swim_feet(delta)

	hero.move_and_slide()
