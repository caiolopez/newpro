extends AppState

func on_enter():
	$"../../SlideReel".reset()
	$"../../SlideReel".start_reel()
	$"../../SlideReel".reel_finished.connect(func():
		Events.curtain_fade_out.emit()
		machine.set_state("AppStateInGame"),
		CONNECT_ONE_SHOT)

func on_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$"../../SlideReel".skip_all()

func on_exit():
	pass
