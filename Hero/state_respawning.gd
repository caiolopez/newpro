extends HeroState

var water_prone: bool = false
var death_prone: bool = false


func on_enter():
	if hero.current_checkpoint != null:
		hero.facing_direction = hero.current_checkpoint.direction

	Events.respawned_at_checkpoint.emit()
	hero.dmg_taker.reset_status()
	
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
