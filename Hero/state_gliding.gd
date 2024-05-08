extends HeroState

func on_enter():
	if hero.is_on_wall_only():
		get_node("../TimerCoyoteWallJump").start()
		print("STARTED COYOTE")

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
	if not Input.is_action_pressed("jump"):
		machine.set_state("StateFalling")
		return
	if hero.is_pushing_wall():
		machine.set_state("StateWallGrabbing")
		return
	if not hero.is_pushing_wall() and not get_node("../TimerCoyoteWallJump").is_stopped() and (Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right")):
		print("***")
		machine.set_state("StateWallJumping")
		return
	



	if Input.is_action_pressed("jump"): hero.velocity.y = hero.GLIDE_VELOCITY
	
	hero.step_lateral_mov(delta)
	
	
	hero.move_and_slide()


func on_exit():
	pass
