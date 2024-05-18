extends HeroState

var water_prone = false
var death_prone = false


func on_enter():
	if hero.current_checkpoint != null:
		hero.facing_direction = hero.current_checkpoint.direction
	if hero.is_on_water:
		machine.set_state("StateFloating")
		return
	machine.set_state("StateIdle")


func on_process(delta: float):
	pass


func on_physics_process(delta: float):
	hero.move_and_slide()


func on_exit():
	pass
