extends BossState

var animation_prefix: StringName = &"idle"
var tn

func on_enter():
	boss.blinking_timer = Utils.create_blinking_timer($"../../GfxController/AnimatedSprite2D", 0.08, 1)
	$"../../DmgDealer".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../DmgTaker".currently_immune = true
	$"../../Flier".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../MoveStraight".process_mode = Node.PROCESS_MODE_DISABLED
	var duration: float = 1.0
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
	$"../../DmgDealer".process_mode = Node.PROCESS_MODE_INHERIT
	$"../../DmgTaker".currently_immune = false
	tn.kill()
