extends Node

var current_region: Region = null

func change_region(to_region: Constants.RegName) -> void:
	if current_region:
		if current_region.name == Constants.RegName.keys()[to_region]:
			print("Current region is already set.")
		else:
			current_region.queue_free()
			print("Region ", current_region.name, " freed.")

	var new_region = get_node_or_null("/root/GameTree/" + Constants.RegName.keys()[to_region])

	if not new_region:
		new_region = load("res://Regions/" + Constants.RegName.keys()[to_region] + ".tscn").instantiate()
		new_region.name = Constants.RegName.keys()[to_region]
		get_node("/root/GameTree").call_deferred("add_child", new_region)
		print("Region ", new_region.name, " loaded from resource.")

	set_current_region(new_region)
	SaveManager.call_deferred("inject_changes_into_current_region")

func set_current_region(region: Region):
	current_region = region
	SaveManager.log_hero_change("current_region", RegionManager.current_region.name)
	SaveManager.add_region_entry(region)
