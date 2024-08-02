extends HeroState

var water_prone: bool = false
var death_prone: bool = false
var destination: Vector2 = Vector2.ZERO
var tween: Tween


func on_enter():
	$"../../Gfx/AnimatedSprite2D".play("teleport")
	Utils.paint_white(true, $"../../Gfx")
	tween = get_tree().create_tween()
	tween.tween_property(hero, "global_position", destination, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func on_process(_delta: float):
	if not tween.is_running():
		tween.kill()
		hero.velocity = Vector2.ZERO
		machine.set_state("StateIdle")
		return


func on_exit():
	Utils.paint_white(false, $"../../Gfx")
