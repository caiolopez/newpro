extends HeroState

var water_prone = false
var death_prone = false
var tween: Tween


func on_enter():
	var destination = hero.original_position
	if hero.current_checkpoint != null:
		destination = hero.current_checkpoint.global_position
	tween = get_tree().create_tween()
	tween.tween_property(hero, "global_position", destination, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)


func on_process(_delta: float):
	if not tween.is_running():
		tween.kill()
		machine.set_state("StateRespawning")
		return


func on_physics_process(_delta: float):
	pass


func on_exit():
	pass
