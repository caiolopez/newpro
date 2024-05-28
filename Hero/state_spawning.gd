extends HeroState

var water_prone: bool = false
var death_prone: bool = false


func on_enter():
	if hero.is_on_water:
		machine.set_state("StateFloating")
		return
	machine.set_state("StateIdle")


func on_process(delta: float):
	pass


func on_physics_process(delta: float):
	pass


func on_exit():
	pass
