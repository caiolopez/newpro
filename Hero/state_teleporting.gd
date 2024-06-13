extends HeroState

var water_prone: bool = false
var death_prone: bool = false
var destination: Vector2 = Vector2.ZERO
var tween: Tween


func on_enter():
	tween = get_tree().create_tween()
	tween.tween_property(hero, "global_position", destination, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func on_process(_delta: float):
	if not tween.is_running():
		tween.kill()
		machine.set_state("StateIdle")
		return
