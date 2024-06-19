extends BossState


func on_enter():
	Utils.create_blinking_timer(boss, 0.08, 1)
	t.wait_time = 1
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStateDying":
			machine.set_state("BStateDead"), CONNECT_ONE_SHOT)
