extends BossState

var animation_prefix: StringName = &"dormant"

func on_enter():
	boss.z_index = 0
	boss.current_stage = 0
	boss.reparametrize_boss()
	boss.change_animation()
	boss.rotation = 0
	boss.reset_physics_interpolation()
	t.stop()
	$"../../DmgDealer".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../DmgTaker".currently_immune = true
	$"../BStateSpinShooting".clockwise = 1
	$"../../Flier".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../MoveStraight".process_mode = Node.PROCESS_MODE_DISABLED
	$"../../Shooter".process_mode = Node.PROCESS_MODE_DISABLED
	
	Events.boss_trigger_entered.connect(_on_boss_triggered)

func _on_boss_triggered(boss_to_wake: Node) -> void:
	if boss_to_wake and boss_to_wake == boss:
		machine.set_state("BStateFirstCentering")

func on_exit():
	Events.boss_trigger_entered.disconnect(_on_boss_triggered)
