extends BossState


func on_enter():
	t.wait_time = 1
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStateDying":
			machine.set_state("BStateDead"), CONNECT_ONE_SHOT)
