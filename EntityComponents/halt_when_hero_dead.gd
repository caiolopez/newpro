class_name HaltWhenHeroDead extends Node

var parent_og_process_mode: ProcessMode

func _ready():
	parent_og_process_mode = get_parent().process_mode
	
	Events.hero_died.connect(func():
		get_parent().process_mode = Node.PROCESS_MODE_DISABLED)
	Events.hero_respawned_at_checkpoint.connect(func():
		get_parent().process_mode = parent_og_process_mode)
