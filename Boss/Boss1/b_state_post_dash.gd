extends BossState


func on_enter():
	t.wait_time = boss.stunned_time_sfter_dash
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStatePostDash":
			machine.set_state("BStateChasing"), CONNECT_ONE_SHOT)
