extends BossState


func on_enter():
	$"../../Flier".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../MoveStraight".process_mode = Node.PROCESS_MODE_INHERIT
	$"../../MoveStraight".set_static_target_pos_to_curr_target_pos()

