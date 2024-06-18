extends BossState


func on_enter():
	var duration: float = 3.0
	var tween = create_tween()
	tween.tween_property(
		boss,
		"global_position",
		center,
		duration).set_trans(Tween.TransitionType.TRANS_QUAD)
	tween.tween_callback(func():
		if machine.current_state.name == "BStateFirstCentering":
			machine.set_state("BStateChasing")
			tween.kill()
			)
