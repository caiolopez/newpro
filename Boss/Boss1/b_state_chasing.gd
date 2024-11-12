extends BossState


func on_enter():
	$"../../GfxController/AnimatedSprite2D".play("idle_stage" + str(boss.current_stage))
	$"../../Flier".inertia_only = false
	$"../../Flier".process_mode = Node.PROCESS_MODE_INHERIT
	$"../../Shooter".process_mode = Node.PROCESS_MODE_DISABLED
	
	t.wait_time = 4
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStateChasing":
			machine.set_state("BStatePreDash")
			$"../../Flier".inertia_only = true, CONNECT_ONE_SHOT)
