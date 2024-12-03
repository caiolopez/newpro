extends BossState

var animation_prefix: StringName = &"idle"
var tn

func on_enter():
	AudioManager.hooks.boss1_wakes_sfx()
	var duration: float = 3.0
	var tween = create_tween()
	tn = tween
	tween.tween_property(
		boss,
		"global_position",
		boss.center,
		duration).set_trans(Tween.TransitionType.TRANS_QUAD)
	tween.tween_callback(func():
		if machine.current_state.name == "BStateFirstCentering":
			machine.set_state("BStateChasing")
			AudioManager.hooks.boss1_fight_start_sfx()
			tween.kill()
			)


func on_exit():
	boss.z_index = 1
	$"../../DmgDealer".process_mode = Node.PROCESS_MODE_INHERIT
	$"../../DmgTaker".currently_immune = false
	tn.kill()
