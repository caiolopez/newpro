extends HeroState

var water_prone: bool = false
var death_prone: bool = false

func on_enter():
	var destination = hero.original_position
	if hero.current_checkpoint_path:
		var curr_checkpoint = get_node(hero.current_checkpoint_path)
		if curr_checkpoint:
			destination = curr_checkpoint.global_position
			hero.facing_direction = hero.current_checkpoint_direction
	hero.global_position = destination

	Events.camera_set_glpos.emit(hero.global_position)
	hero.force_water_detection()

	machine.set_state("StateIdle")

func on_exit():
	Utils.create_blinking_timer(hero, 0.08, 0.5)
