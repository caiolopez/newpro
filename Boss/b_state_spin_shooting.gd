extends BossState

var duration: float = 5.0
var tn: Tween
var clockwise: int = 1

func on_enter():
	boss.rotation_degrees = 0
	var tween = create_tween()
	tn = tween
	tween.tween_property(
		boss,
		"rotation_degrees",
		1800 * clockwise,
		duration).set_trans(Tween.TransitionType.TRANS_QUAD).set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.tween_callback(func():
		if machine.current_state.name == "BStateSpinShooting":
			tween.kill()
			clockwise *= -1
			machine.set_state("BStateChasing")
			$"../../Shooter".process_mode = Node.PROCESS_MODE_DISABLED
			)


func on_process(_delta):
	if tn.get_total_elapsed_time() > 0.5\
	and tn.get_total_elapsed_time() < duration - 1:
		$"../../Shooter".process_mode = Node.PROCESS_MODE_INHERIT
	else:
		$"../../Shooter".reset_behavior()
		$"../../Shooter".process_mode = Node.PROCESS_MODE_DISABLED


func on_exit():
	tn.kill()
