extends BossState

var tn

func on_enter():
	$"../../Flier".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../MoveStraight".process_mode = Node.PROCESS_MODE_DISABLED
	var duration: float = 2.0
	var tween = create_tween()
	tn = tween
	tween.tween_property(
		boss,
		"global_position",
		boss.center,
		duration).set_trans(Tween.TransitionType.TRANS_QUAD)
	tween.tween_callback(func():
		if machine.current_state.name == "BStateCentering":
			machine.set_state("BStateSpinShooting")
			tween.kill()
			)


func on_exit():
	tn.kill()
