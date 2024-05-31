extends HeroState

var water_prone: bool = false
var death_prone: bool = false


func on_enter():
	Events.camera_shake.emit()
	timer_death_snapshot.start()
	hero.get_node("HeroSprite").paint_white(true)
	

func on_process(_delta: float):
	if timer_death_snapshot.is_stopped():
		hero.get_node("HeroSprite").paint_white(false)
		machine.set_state("StateTweeningToRespawn")
	


func on_physics_process(_delta: float):
	pass


func on_exit():
	pass
