extends BossState


func on_enter():
	$"../../Flier".inertia_only = false
	$"../../Flier".process_mode = Node.PROCESS_MODE_INHERIT
	t.wait_time = 4
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStateChasing":
			machine.set_state("BStatePreDash")
			$"../../Flier".inertia_only = true, CONNECT_ONE_SHOT)
