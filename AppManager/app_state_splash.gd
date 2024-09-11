extends AppState

@onready var reel = Hud.get_node("SlideReel")

func on_enter():
	reel.reset()
	reel.start_reel()
	reel.reel_finished.connect(func():
		Events.curtain_fade_out.emit()
		machine.set_state("AppStateInGame"),
		CONNECT_ONE_SHOT)

func on_process(_delta):
	if Input.is_action_just_pressed("cancel")\
	or Input.is_action_just_pressed("accept"):
		if Input.is_action_pressed("down"):
			reel.skip_all()
		else:
			reel.skip_current_slide()

func on_exit():
	Events.game_started.emit()
	AppManager.is_time_running = true
