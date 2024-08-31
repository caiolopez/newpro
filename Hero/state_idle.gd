extends HeroState

var water_prone: bool = true
var death_prone: bool = true

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("idle")
	if Input.is_action_pressed("jump")\
	and not timer_buffer_jump.is_stopped():
		timer_buffer_jump.stop()
		if DebugTools.print_stuff: print("BUFFERED JUMP")
		machine.set_state("StateJumping")
		return

func on_process(_delta: float):
	hero.step_shooting()

	if hero.is_on_floor()\
	and not hero.pelvis_rc.is_colliding()\
	and not hero.shoulder_rc.is_colliding()\
	and hero.next_grd_height_rc.is_colliding()\
	and hero.is_pushing_wall():
		machine.set_state("StateVaulting")
		return

	if Input.is_action_just_pressed("jump")\
	and not hero.is_on_ceiling()\
	and hero.is_on_floor():
		machine.set_state("StateJumping")
		return

	if Utils.is_pushing_sides()\
	and not hero.is_pushing_wall()\
	and not hero.is_on_ceiling()\
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
