extends HeroState

var water_prone: bool = true
var death_prone: bool = true

var sticky_offset: Vector2
var sticky: Node2D = null
const inverted: bool = true

func on_enter():
	hero.velocity.y = 0
	
	$"../../Gfx/AnimatedSprite2D".play("wallgrab")
	if $"../../Gfx/Muzzle".is_playing(): $"../../Gfx/Muzzle".hide()
	$"../../Shooter".position = Vector2(88, -40)
	$"../../Gfx/Muzzle".position = Vector2(-$"../../Shooter".position.x - 154, $"../../Shooter".position.y)
	$"../../Gfx/Muzzle".flip_h = true
	
	var c = hero.shoulder_rc.get_collider()
	if c and c.is_in_group("sticky"):
		sticky = c
		sticky_offset = Vector2(hero.position.x - c.position.x, hero.position.y - c.position.y)


func on_process(_delta: float):
	hero.step_shooting(inverted)

	if hero.is_on_floor():
		machine.set_state("StateIdle")
		return

	if not hero.is_pushing_wall():
		machine.set_state("StateGliding")
		return

	if Input.is_action_just_released("jump"):
		machine.set_state("StateFalling")
		return


func on_physics_process(_delta: float):
	if sticky: hero.position = sticky.position + sticky_offset
	hero.move_and_slide()


func on_exit():
	$"../../Shooter".return_to_og_pos()
	$"../../Gfx/Muzzle".position = $"../../Shooter".position
	$"../../Gfx/Muzzle".flip_h = false
	
	sticky = null
	pass
