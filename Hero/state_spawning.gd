extends HeroState

var water_prone = false
var death_prone = false


func on_enter():
	pass


func on_process(delta: float):
	if hero.is_on_water:
		machine.set_state("StateFloating")
		return
	machine.set_state("StateIdle")
	


func on_physics_process(delta: float):

	hero.move_and_slide()


func on_exit():
	pass
