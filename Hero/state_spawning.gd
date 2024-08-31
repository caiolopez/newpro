extends HeroState

var water_prone: bool = false
var death_prone: bool = false

func on_enter():
	var destination = hero.original_position
	if hero.current_checkpoint_path and has_node(hero.current_checkpoint_path):
		destination = get_node(hero.current_checkpoint_path).global_position
		hero.facing_direction = get_node(hero.current_checkpoint_path).direction
	hero.global_position = destination
	
	Events.camera_set_glpos.emit(hero.global_position)
	AppManager.is_time_running = true
	machine.set_state("StateIdle")

func on_exit():
	Utils.create_blinking_timer(hero, 0.08, 0.5)
