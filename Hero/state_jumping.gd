extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	hero.velocity.y = hero.JUMP_VELOCITY

func on_process(delta: float):
	if hero.on_wall_value_just_changed\
	and not hero.is_on_wall():
		timer_leaving_wall.start()
	if hero.is_move_dir_away_from_last_wall(false)\
	and Input.is_action_just_pressed('jump')\
	and not timer_leaving_wall.is_stopped():
		machine.set_state("StateWallJumping")
	if hero.is_just_on_floor:
		print("*** IS JUST ON FLOOR ***")
		machine.set_state("StateIdle")
		return
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return
	if Input.is_action_just_pressed('jump')\
	and hero.is_pushing_wall():
		machine.set_state("StateWallClimbing")
	if hero.velocity.y > 0:
		machine.set_state("StateFalling")
		return
	
	if Input.is_action_just_pressed("shoot"): hero.shoot_regular()

		
func on_physics_process(delta: float):
	if  hero.headbutt_assist.is_colliding()\
	and hero.velocity.y < hero.HEADBUTT_THRESHOLD:
		hero.global_position.x = hero.headbutt_assist.get_collision_point().x + (%HeroCollider.shape.get_rect().size.x/2 + 1) * hero.facing_direction
		print(abs(hero.velocity.y))
	
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	
	if Input.is_action_just_released('jump'): hero.velocity.y *= 0.25
	
	hero.move_and_slide()


func on_exit():
	pass
