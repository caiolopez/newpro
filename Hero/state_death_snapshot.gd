extends HeroState

var water_prone = false
var death_prone = false


func on_enter():
	get_node("../TimerDeathSnapshot").start()
	hero.get_node("HeroSprite").paint_white(true)
	

func on_process(delta: float):
	if get_node("../TimerDeathSnapshot").is_stopped():
		hero.get_node("HeroSprite").paint_white(false)
		machine.set_state("StateTweeningToRespawn")
	


func on_physics_process(delta: float):
	pass


func on_exit():
	pass
