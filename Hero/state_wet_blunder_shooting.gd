extends HeroState

var water_prone: bool = false
var death_prone: bool = true


func on_enter():
	timer_blunder_shoot_duration.set_wait_time(hero.BLUNDER_UNDERWATER_DURATION)
	hero.velocity.x = hero.BLUNDER_UNDERWATER_VELOCITY.x*hero.facing_direction
	hero.velocity.y = hero.BLUNDER_UNDERWATER_VELOCITY.y
	timer_blunder_shoot_duration.start()
	hero.shooter.shoot()

func on_process(_delta: float):
	if timer_blunder_shoot_duration.is_stopped():
		machine.set_state("StateFloating")
		return


func on_physics_process(_delta: float):
	hero.move_and_slide()


func on_exit():
	timer_blunder_shoot_cooldown.start()
