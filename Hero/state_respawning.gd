extends HeroState

var water_prone: bool = false
var death_prone: bool = false

var curr_signal: int = 1

func on_enter():
	Events.hero_respawned_at_checkpoint.emit()

func on_process(_delta: float):
	if hero.innards_rc.is_colliding():
		hero.global_position.x += 128 * curr_signal
		curr_signal *= -1
		return

	if hero.is_in_water:
		machine.set_state("StateFloating")
		return

	machine.set_state("StateIdle")
	return

func on_physics_process(_delta: float):
	hero.move_and_slide()

func on_exit():
	Utils.create_blinking_timer(hero, 0.08, 0.5)
