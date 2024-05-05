extends HeroState

func on_enter():
	pass

func on_process(delta: float):
	pass

		
func on_physics_process(delta: float):
	# Add the gravity.
	if not hero.is_on_floor(): hero.velocity.y += hero.gravity * delta

	# Jump
	if Input.is_action_just_pressed('jump') and hero.is_on_floor(): hero.velocity.y = hero.JUMP_VELOCITY
	if Input.is_action_just_released('jump') and hero.velocity.y < 0: hero.velocity.y = 0

	# Change hero facing direction and move
	if Input.is_action_pressed("move_left"):
		hero.facing_direction = -1
		hero.velocity.x = hero.facing_direction * hero.SPEED
	
	elif Input.is_action_pressed("move_right"):
		hero.facing_direction = 1
		hero.velocity.x = hero.facing_direction * hero.SPEED
		
	else: hero.velocity.x = 0

	hero.move_and_slide()


func on_exit():
	pass
