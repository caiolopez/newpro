extends BossState


func on_enter():
	t.wait_time = 1
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStatePreDash":
			machine.set_state("BStateDashing"), CONNECT_ONE_SHOT)
