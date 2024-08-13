extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	PropManager.place_prop(Vector2(hero.global_position.x, hero.last_water_surface), &"splash")

func on_process(_delta: float):
	if hero.is_on_wall()\
	and hero.facing_direction == round(hero.get_wall_normal().x):
		if Utils.is_pushing_sides():
			$"../../Gfx/AnimatedSprite2D".play("water_swim_v")
		else:		
			$"../../Gfx/AnimatedSprite2D".play("water_swim_v")
	else:
		if Utils.is_pushing_sides():
			$"../../Gfx/AnimatedSprite2D".play("water_swim")
		else:		
			$"../../Gfx/AnimatedSprite2D".play("water_idle")
	
	if hero.is_input_blunder_shoot()\
	and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateWetBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shoot()

	if not hero.is_in_water:
		machine.set_state("StateIdle")
		return

	if hero.can_dive:
		machine.set_state("StateDescending")
		return

	if Input.is_action_just_pressed('jump')\
	and hero.is_on_floor():
		PropManager.place_prop(Vector2(hero.global_position.x, hero.last_water_surface), &"splash")
		machine.set_state("StateJumping")

	if Input.is_action_just_pressed('jump')\
	and hero.is_pushing_wall()\
	and hero.is_head_above_water():
		PropManager.place_prop(Vector2(hero.global_position.x, hero.last_water_surface), &"splash")
		machine.set_state("StateJumping")


func on_physics_process(delta: float):
	

	if not hero.can_dive:
		hero.velocity.y = (hero.velocity.y - (hero.BUOYANCY * (hero.global_position.y - (hero.last_water_surface))*delta - 50))*pow(0.80, 1-delta)

	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
