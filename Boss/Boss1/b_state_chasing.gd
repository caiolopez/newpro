extends BossState

var animation_prefix: StringName = &"idle"

func on_enter():
	boss.change_animation()
	$"../../Flier".inertia_only = false
	$"../../Flier".process_mode = Node.PROCESS_MODE_INHERIT
	$"../../Shooter".process_mode = Node.PROCESS_MODE_DISABLED
	
	t.wait_time = 4
	t.start()
	t.timeout.connect(func():
		if machine.current_state.name == "BStateChasing":
			machine.set_state("BStatePreDash")
			$"../../Flier".inertia_only = true, CONNECT_ONE_SHOT)

func on_physics_process(_delta):
	if AppManager.hero.is_on_floor():
		$"../../Flier".target_offset = Vector2(0.0, 0.0)
	else:
		$"../../Flier".target_offset = Vector2(0.0, 160.0)
