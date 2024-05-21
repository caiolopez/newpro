extends HeroState

var water_prone = true
var death_prone = true


func on_enter():
	pass

func on_process(delta: float):
	if hero.is_on_floor()\
	and not hero.pelvis_rc.is_colliding()\
	and not hero.shoulder_rc.is_colliding()\
	and  hero.next_grd_height.is_colliding()\
	and hero.is_pushing_wall():
		hero.global_position.y = hero.next_grd_height.get_collision_point().y - %HeroCollider.shape.get_rect().size.y/2 - 1
		print("AUTO SNAP ON STAIRS")
		
		
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if hero.is_on_floor() and hero.velocity.x == 0: machine.set_state("StateIdle")
	if not hero.is_on_floor() and hero.velocity.y > 0:
		timer_coyote_jump.start()
		machine.set_state("StateFalling")
		return
	if Input.is_action_just_pressed('jump'): machine.set_state("StateJumping")

	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

		
func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
