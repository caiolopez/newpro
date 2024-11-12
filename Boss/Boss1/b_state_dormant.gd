extends BossState


func on_enter():
	boss.z_index = 0
	boss.current_stage = 0
	boss.reparametrize_boss()
	boss.rotation = 0
	t.stop()
	$"../../DmgDealer".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../DmgTaker".currently_immune = true
	$"../BStateSpinShooting".clockwise = 1
	$"../../Flier".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../MoveStraight".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../Shooter".process_mode = Node.PROCESS_MODE_DISABLED
	
	Events.boss_trigger_entered.connect(func(b):
		if b and b == boss:
			machine.set_state("BStateFirstCentering"), CONNECT_ONE_SHOT)
