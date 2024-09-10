extends AppState

func on_enter():
	$"../../SplashReel".reset()
	$"../../SplashReel".start_reel()
	$"../../SplashReel".reel_finished.connect(func():
		machine.set_state("AppStateInGame"),
		CONNECT_ONE_SHOT)

func on_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$"../../SplashReel".skip_all()

func on_exit():
	pass
