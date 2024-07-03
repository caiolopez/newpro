extends Node

var current_region: Region = null

func change_region(to_region: Constants.RegName) -> void:
	if current_region:
		current_region.queue_free()
	var new_region = load("res://Regions/" + Constants.RegName.keys()[to_region] + ".tscn").instantiate()
	get_tree().root.add_child(new_region)
	new_region.name = Constants.RegName.keys()[to_region]

func set_current_region(region: Region):
	current_region = region
	if not SaveManager.region_dictionaries.has(region.name):
		SaveManager.region_dictionaries[region.name] = SaveManager.region_persistence.duplicate()
	print(current_region, " | ", SaveManager.region_dictionaries)

func _process(_delta):
	if Input.is_action_just_pressed("up"): change_region(Constants.RegName.HUB)
