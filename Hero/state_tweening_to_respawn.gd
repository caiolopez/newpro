extends HeroState

var water_prone: bool = false
var death_prone: bool = false
var tween: Tween

func on_enter():
	Events.hero_started_tweening_to_respawn.emit()
	AudioManager.hooks.hero_tweening_to_respawn_sfx()
	$"../../Gfx/AnimatedSprite2D".play("teleport")

	var destination = hero.original_position
	if hero.current_checkpoint_path:
		var curr_checkpoint = get_node(hero.current_checkpoint_path)
		if curr_checkpoint:
			destination = curr_checkpoint.spawn_pivot
			hero.facing_direction = hero.current_checkpoint_direction
	tween = get_tree().create_tween()
	tween.tween_property(hero, "global_position", destination, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)

func on_process(_delta: float):
	if not tween.is_running():
		tween.kill()
		machine.set_state("StateRespawning")
		return
