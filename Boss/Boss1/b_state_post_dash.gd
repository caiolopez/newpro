extends BossState

var animation_prefix: StringName = &"idle"

func on_enter():
	AudioManager.hooks.boss1_post_dash_sfx()
	t.wait_time = boss.stunned_time_after_dash
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStatePostDash":
			machine.set_state("BStateChasing"), CONNECT_ONE_SHOT)
