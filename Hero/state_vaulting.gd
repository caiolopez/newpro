extends HeroState

var water_prone = true
var death_prone = true

func on_enter():
	hero.velocity.y = hero.VAULT_VELOCITY
	hero.global_position.y = hero.next_grd_height.get_collision_point().y\
	- %HeroCollider.shape.get_rect().size.y/2 - 1


func on_process(delta: float):	
	if hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()


func on_physics_process(delta: float):
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	hero.move_and_slide()


func on_exit():
	pass
