extends BossState


func on_enter():
	t.wait_time = 2
	t.start()

func on_process(_delta: float):
	if t.is_stopped():
		machine.set_state("BStateDashing")


func on_physics_process(_delta: float):
	pass


func on_exit():
	pass
