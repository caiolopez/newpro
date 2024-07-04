extends Node2D

@export var print_stuff: bool = true
@export var input_stuff: bool = true

func _process(_delta):
	input_bin()
	print_bin()
	
func input_bin():
	if not input_stuff: return
	#if Input.is_action_just_pressed("up"): RegionManager.change_region(Constants.RegName.HUB)
	#if Input.is_action_just_pressed("up"): SaveManager.print_all_dics()
	if Input.is_action_just_pressed("up"): SaveManager.save_file()
	if Input.is_action_just_pressed("center_map"): SaveManager.load_file()
	if Input.is_action_just_pressed("pause"):
		SaveManager.inject_changes_into_current_region()
		SaveManager.inject_changes_into_hero()
	

func print_bin():
	if not print_stuff: return
	
