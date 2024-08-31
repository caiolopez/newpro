extends HeroState

var water_prone: bool = true
var death_prone: bool = true

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("wallclimb")
	hero.velocity.y = hero.CLIMB_VELOCITY

func on_process(_delta: float):
	hero.step_shooting()

	if Input.is_action_just_pressed("jump"):
		if hero.is_pushing_wall():
			$"../../Gfx/AnimatedSprite2D".frame = 0
			$"../../Gfx/AnimatedSprite2D".play("wallclimb")
			hero.velocity.y = hero.CLIMB_VELOCITY
			return

	if hero.velocity.y < 0\
	and not hero.pelvis_rc.is_colliding()\
	and not hero.shoulder_rc.is_colliding()\
	and hero.next_grd_height_rc.is_colliding()\
	and hero.is_pushing_wall():
		machine.set_state("StateVaulting")
		return
	
	if hero.velocity.y > 0:
		machine.set_state("StateFalling")

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return
		
	if Input.is_action_just_released("jump"):
		hero.velocity.y *= 0.5

	if not hero.is_on_wall():
		$"../../Gfx/AnimatedSprite2D".play("vault")

func on_physics_process(delta: float):
	hero.step_grav(delta)
	hero.step_lateral_mov(delta)
	hero.move_and_slide()
