extends BossState

var animation_prefix: StringName = &"pre_dash"

func on_enter():
	AudioManager.hooks.boss1_pre_dash_sfx()
	boss.change_animation()
	t.wait_time = 1
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStatePreDash":
			machine.set_state("BStateDashing"), CONNECT_ONE_SHOT)
