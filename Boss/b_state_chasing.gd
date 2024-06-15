extends BossState


func on_enter():
	$"../../Flier".process_mode = Node.PROCESS_MODE_INHERIT
	$"../Timer".wait_time = 4
	$"../Timer".start()
	$"../Timer".timeout.connect(func():
		machine.set_state("BStatePreDash"))


func on_process(_delta: float):
	pass


func on_physics_process(_delta: float):
	pass


func on_exit():
	$"../../Flier".inertia_only = true
	pass #$"../../Flier".process_mode = Node.PROCESS_MODE_DISABLED
