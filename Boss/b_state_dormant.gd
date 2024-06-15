extends BossState


func on_enter():
	Events.boss_trigger_entered.connect(on_boss_started)

func on_boss_started(b):
	if b and b == boss:
		machine.set_state("BStateFirstCentering")

func on_exit():
	Events.boss_trigger_entered.disconnect(on_boss_started)
