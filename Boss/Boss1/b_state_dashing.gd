extends BossState

var _timer: Timer

func _ready():
	_timer = Timer.new()
	_timer.one_shot = true
	_timer.wait_time = 1.0
	_timer.timeout.connect(func():
		machine.set_state("BStatePostDash")
		)
	add_child(_timer)

func on_enter():
	AudioManager.play_sfx(&"boss1_charge", -8.0)
	$"../../Flier".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../MoveStraight".process_mode = Node.PROCESS_MODE_INHERIT
	$"../../MoveStraight".set_static_target_pos_to_curr_target_pos()
	_timer.start()

func on_exit():
	AudioManager.stop_sfx(&"boss1_charge")
	if _timer.time_left > 0:
		_timer.stop()
	$"../../MoveStraight".process_mode = Node.PROCESS_MODE_DISABLED
	AppManager.camera.shake()
