extends BossState


func on_enter():
	current_cycle = 0
	t.stop()
	$"../../Flier".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../MoveStraight".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../Shooter".process_mode = Node.PROCESS_MODE_DISABLED
	
	Events.boss_trigger_entered.connect(func(b):
		if b and b == boss:
			machine.set_state("BStateFirstCentering"), CONNECT_ONE_SHOT)
