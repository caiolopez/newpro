extends HeroState

var water_prone: bool = false
var death_prone: bool = false


func on_enter():
	pass


func on_process(delta: float):
	pass


func on_physics_process(delta: float):
	hero.move_and_slide()


func on_exit():
	pass
