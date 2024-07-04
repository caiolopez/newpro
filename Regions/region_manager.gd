extends Node

var current_region: Region = null

func change_region(to_region: Constants.RegName) -> void:
	if current_region:
		current_region.queue_free()
	var new_region = load("res://Regions/" + Constants.RegName.keys()[to_region] + ".tscn").instantiate()
	new_region.name = Constants.RegName.keys()[to_region]
	get_tree().root.add_child(new_region)

func set_current_region(region: Region):
	current_region = region
	SaveManager.add_region_entry(region)
