extends HeroState

var water_prone: bool = false
var death_prone: bool = false


func on_enter():
	hero.velocity = Vector2.ZERO
	Events.camera_shake.emit()
	Events.hero_died.emit()
	timer_death_snapshot.start()
	Utils.paint_white(true, hero.get_node("HeroSprite"))
	

func on_process(_delta: float):
	if timer_death_snapshot.is_stopped():
		Utils.paint_white(false, hero.get_node("HeroSprite"))
		machine.set_state("StateTweeningToRespawn")


func on_physics_process(_delta: float):
	pass


func on_exit():
	pass
