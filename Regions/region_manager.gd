extends Node

var current_region: Region = null

func change_region(to_region: Constants.RegName) -> void:
	if current_region:
		current_region.queue_free()
		print("Region ", current_region.name, " freed.")

	var new_region = get_node_or_null("/root/Level/" + Constants.RegName.keys()[to_region])

	if not new_region:
		new_region = load("res://Regions/" + Constants.RegName.keys()[to_region] + ".tscn").instantiate()
		new_region.name = Constants.RegName.keys()[to_region]
		get_node("/root/Level").call_deferred("add_child", new_region)
		print("Region ", new_region.name, " loaded from resource.")

	current_region = new_region

func set_current_region(region: Region):
	current_region = region
	SaveManager.add_region_entry(region)
