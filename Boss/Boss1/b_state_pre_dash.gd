extends BossState


func on_enter():
	AudioManager.hooks.boss1_pre_dash_sfx()
	$"../../GfxController/AnimatedSprite2D".play("pre_dash_stage" + str(boss.current_stage))
	t.wait_time = 1
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStatePreDash":
			machine.set_state("BStateDashing"), CONNECT_ONE_SHOT)
