extends BossState


func on_enter():
	$"../Timer".wait_time = 4
	$"../Timer".start()
	$"../Timer".timeout.connect(func():
		machine.set_state("BStateDashing"))


func on_process(_delta: float):
	pass


func on_physics_process(_delta: float):
	pass


func on_exit():
	pass
