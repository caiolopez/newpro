extends HeroState

var water_prone: bool = false
var death_prone: bool = false

func on_enter():
	Events.hero_respawned_at_checkpoint.emit()
	
	if hero.is_in_water:
		machine.set_state("StateFloating")
		return
	machine.set_state("StateIdle")

func on_process(_delta: float):
	pass

func on_physics_process(_delta: float):
	hero.move_and_slide()

func on_exit():
	Utils.create_blinking_timer(hero, 0.08, 0.5)
