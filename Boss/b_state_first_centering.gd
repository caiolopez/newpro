extends BossState

var tn
var blinking_timer: Timer

func on_enter():
	blinking_timer = Utils.create_blinking_timer(boss, 0.08)
	var duration: float = 3.0
	var tween = create_tween()
	tn = tween
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


func on_exit():
	$"../../DmgDealer".process_mode = Node.PROCESS_MODE_INHERIT
	$"../../DmgTaker".immune = false
	tn.kill()
	blinking_timer.queue_free()
