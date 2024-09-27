extends HeroState

var water_prone: bool = false
var death_prone: bool = false

func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("blunderjump")
	hero.velocity = Vector2.ZERO
	hero.dmg_taker.currently_immune = true
	print(Utils.parse_time_as_string(AppManager.game_time, false))

func on_physics_process(delta: float):
	if Input.is_action_just_released("Debug Action 2"):
		machine.set_state("StateIdle")
		return

	if Input.is_action_pressed("up"):
		hero.global_position.y -= 1000 * delta
	if Input.is_action_pressed("down"):
		hero.global_position.y += 1000 * delta
	if Input.is_action_pressed("left"):
		hero.global_position.x -= 1000 * delta
	if Input.is_action_pressed("right"):
		hero.global_position.x += 1000 * delta

func on_exit():
	hero.dmg_taker.currently_immune = false
