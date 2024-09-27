extends AppState

@onready var reel = UI.get_node("SlideReel")

func on_enter():
	if AppManager.developer_mode:
		machine.set_state("AppStateNewGameInit")
		return

	get_tree().paused = true
	reel.reset()
	reel.start_reel()
	reel.reel_finished.connect(func():
		machine.set_state("AppStateMainMenu"),
		CONNECT_ONE_SHOT)

func on_process(_delta):
	if Input.is_action_just_pressed("cancel")\
	or Input.is_action_just_pressed("accept"):
		if Input.is_action_pressed("down"):
			reel.skip_all()
		else:
			reel.skip_current_slide()
