extends HeroState

var water_prone: bool = true
var death_prone: bool = true

func on_enter():
	hero.velocity.y = hero.VAULT_VELOCITY
	hero.global_position.y = hero.next_grd_height.get_collision_point().y\
	- %HeroCollider.shape.get_rect().size.y/2 - 1


func on_process(_delta: float):
	if Input.is_action_just_pressed("shoot"):
		hero.shooter.shoot_ad_hoc(hero.regular_shot_speed)

	if hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return


func on_physics_process(delta: float):
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	hero.move_and_slide()


func on_exit():
	pass
