extends HeroState

var water_prone: bool = true
var death_prone: bool = true


func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("idle")
	if Input.is_action_pressed('jump')\
	and not timer_buffer_jump.is_stopped():
		timer_buffer_jump.stop()
		print("BUFFERED JUMP")
		machine.set_state("StateJumping")
		return

func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
	and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shooter.shoot_ad_hoc(hero.regular_shot_speed)

	if hero.is_on_floor()\
	and not hero.pelvis_rc.is_colliding()\
	and not hero.shoulder_rc.is_colliding()\
	and  hero.next_grd_height.is_colliding()\
	and hero.is_pushing_wall():
		hero.global_position.y = hero.next_grd_height.get_collision_point().y - %HeroCollider.shape.get_rect().size.y/2 - 1
		print("AUTO SNAP ON STAIRS")

	if Input.is_action_just_pressed('jump')\
	and hero.is_on_floor():
		machine.set_state("StateJumping")
		return

	if hero.velocity.x != 0\
	and hero.is_on_floor():
		machine.set_state("StateWalking")
		return

	if not hero.is_on_floor()\
	and hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return


func on_physics_process(delta: float):

	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)

	hero.move_and_slide()


func on_exit():
	pass
