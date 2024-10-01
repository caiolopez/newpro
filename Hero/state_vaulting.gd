extends HeroState

var water_prone: bool = true
var death_prone: bool = true

var target_y_position: float
var target_x_position: float

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("vault")
	hero.velocity.y = hero.VAULT_VELOCITY
	target_y_position = hero.next_grd_height_rc.get_collision_point().y - %HeroCollider.shape.get_rect().size.y/2 - 5
	target_x_position = hero.global_position.x + 10 * hero.facing_direction

func on_process(_delta: float):
	if hero.step_shooting():
		return

	if Input.is_action_just_pressed("jump"):
		machine.set_state("StateJumping")
		return

	if hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return

	if not hero.next_grd_height_rc.is_colliding():
		machine.set_state("StateFalling")
		return

func on_physics_process(delta: float):
	hero.global_position.y = lerp(hero.global_position.y, target_y_position, 15 * delta)
	hero.global_position.x = lerp(hero.global_position.x, target_x_position, 15 * delta)
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	hero.move_and_slide()
