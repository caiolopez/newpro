extends HeroState

var water_prone: bool = true
var death_prone: bool = true
var sticky_offset: Vector2
var sticky: Node2D = null

func on_enter():
	hero.velocity.y = 0
	
	var c = hero.shoulder_rc.get_collider()
	if c and c.is_in_group("sticky"):
		sticky = c
		sticky_offset = Vector2(hero.position.x - c.position.x, hero.position.y - c.position.y)


func on_process(_delta: float):
	if hero.is_input_blunder_shoot()\
		and timer_blunder_shoot_cooldown.is_stopped():
		machine.set_state("StateBlunderShooting")
		return

	if Input.is_action_just_pressed("shoot"):
		hero.shooter.shoot_ad_hoc(hero.regular_shot_speed)

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return

	if not hero.is_pushing_wall():
		machine.set_state("StateGliding")
		return

	if Input.is_action_just_released('jump'):
		machine.set_state("StateFalling")
		return


func on_physics_process(_delta: float):
	if sticky: hero.position = sticky.position + sticky_offset
	hero.move_and_slide()


func on_exit():
	sticky = null
	pass
