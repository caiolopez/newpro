extends BossState

var animation_prefix: StringName = &"idle"
var tn
var immunity_timer: Timer

func _ready():
	immunity_timer = Timer.new()
	immunity_timer.one_shot = true
	immunity_timer.wait_time = 0.1
	immunity_timer.timeout.connect(func():
		if machine.current_state.name == "BStateCentering":
			$"../../DmgTaker".currently_immune = true
		)
	add_child(immunity_timer)

func on_enter():
	boss.blinking_timer = Utils.create_blinking_timer($"../../GfxController/AnimatedSprite2D", 0.08, 1)
	$"../../DmgDealer".process_mode = Node.PROCESS_MODE_DISABLED

	immunity_timer.start()
	
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
