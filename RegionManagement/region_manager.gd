extends Node

var current_region: Region = null

func change_region(to_region: Constants.RegName) -> void:
	var to_region_name = Constants.RegName.find_key(to_region)
	if current_region:
		if current_region.name == to_region_name:
			if DebugTools.print_stuff: print("Current region is already set.")
			return
		else:
			current_region.queue_free()
			if DebugTools.print_stuff: print("Region ", current_region.name, " freed.")

	var new_region = get_node_or_null("/root/GameTree/" + to_region_name)

	if not new_region:
		new_region = load("res://Regions/" + to_region_name + ".tscn").instantiate()
		new_region.name = to_region_name
		get_node("/root/GameTree").add_child(new_region)
		if DebugTools.print_stuff: print("Region ", new_region.name, " loaded from resource.")

	set_current_region(new_region)
	SaveManager.inject_changes_into_regions()

func get_region_from_node(node: Node) -> Region:
	var region: Region = null
	for ancestor in Utils.get_ancestors(node):
		if ancestor is Region:
			if DebugTools.print_stuff: print("Node ", node.name, " is from region: ", ancestor.name, ".")
			region = ancestor
			break
	return region

func set_current_region(region: Region):
	current_region = region
	SaveManager.add_region_entry(region)
	SaveManager.log_hero_change("current_region", RegionManager.current_region.name)

func infer_current_region_from_last_floor():
	if current_region: return
	var hero: Hero = AppManager.hero
	if hero.get_slide_collision_count() > 0:
		var latest_floor: Object = hero.get_slide_collision(0).get_collider()
		if latest_floor and is_instance_valid(latest_floor):
			var region_from_floor = get_region_from_node(latest_floor)
			if region_from_floor:
				set_current_region(region_from_floor)
				if DebugTools.print_stuff: print("RegionManager.current_region set to ", region_from_floor.name, " via touching floor." )
	else: if DebugTools.print_stuff: print("Couldn't infer region.")
