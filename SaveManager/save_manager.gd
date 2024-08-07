extends Node

var hero_persistence: Dictionary = {}
var regions: Dictionary = {}
var current_slot: int

func _ready():
	ComboParser.combo_performed.connect(func(combo): if combo == "SaveCurrentGame": save_file())
	ComboParser.combo_performed.connect(func(combo): if combo == "LoadCurrentGame": load_from_slot())

func add_region_entry(region: Region):
	if not regions.has(region.name):
		regions[region.name] = {}
		print("region entry added for ", region.name)

func log_entity_change(entity: Node, value):
	var from_region: Region = RegionManager.get_region_from_node(entity)
	add_region_entry(from_region)
	var key: NodePath = entity.get_path()
	if from_region and key and value:
		regions[from_region.name][key] = value
	else:
		print("logging ", entity.name, "'s ", key, " as ", value, " failed.")

func log_hero_change(key: String, value):
	hero_persistence[key] = value

func save_file():
	if RegionManager.current_region:
		hero_persistence["current_region"] = RegionManager.current_region.name
	hero_persistence["elapsed_time"] = AppManager.game_time
	
	var save = {"hero_changes": hero_persistence, "entity_changes": regions}
	var json_string = JSON.stringify(save, "\t")
	var file = FileAccess.open("user://save_" + str(current_slot) + ".dat", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		print("Saved.")
	else:
		print("Error saving game: ", FileAccess.get_open_error())

func load_file():
	var file = FileAccess.open("user://save_" + str(current_slot) + ".dat", FileAccess.READ)
	if file == null:
		print("File: user://save_" + str(current_slot) + ".dat does not exist.")
		return
	var data = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(data)
	if error == OK:
		if typeof(json.data) == TYPE_DICTIONARY: print(json.data)
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data, " at line ", json.get_error_line())

	hero_persistence = json.data["hero_changes"]
	regions = json.data["entity_changes"]

func inject_changes_into_regions():
	if not RegionManager.current_region:
		return
	for region_name in regions.keys():
		if has_node("/root/GameTree/" + region_name):
			var region_changes = regions[region_name]
			for key in region_changes.keys():
				var value = region_changes[key]
				if typeof(value) == TYPE_DICTIONARY:
					var sub_dict = value
					for sub_key in sub_dict:
						match sub_key:
							"move_to":
								if has_node(key):
									get_node(key).global_position = str_to_var("Vector2" + str(sub_dict[sub_key]))
							"saga": pass
				else:
					match value:
						"dead":
							if has_node(key):
								get_node(key).queue_free()
						"on_and_saved":
							if has_node(key):
								get_node(key).force_group_on_and_saved()

func inject_changes_into_hero():
	var h = Utils.find_hero()
	for key in hero_persistence:
		var value = hero_persistence[key]
		match key:
			"current_checkpoint_path":
				h.current_checkpoint_path = value
			"can_dive": h.can_dive = value
			"elapsed_time": AppManager.game_time = value
			"current_region":
				RegionManager.change_region(Constants.RegName.get(value))

func load_from_slot(slot: int = current_slot):
	current_slot = slot
	load_file()
	inject_changes_into_hero()
	inject_changes_into_regions()
	Utils.find_hero().insta_spawn()
	print("Game loaded from slot ", slot, ".")

func clear_slot(slot: int):
	var path = "user://save_" + str(slot) + ".dat"
	return DirAccess.remove_absolute(path) == OK

func print_all_dics():
	print("")
	print("Hero Persistence Dictionary: ")
	print("------------------------------")
	print(hero_persistence)
	print("")
	print("Regions Dictionary: ")
	print("------------------------------")
	print(regions)
	print("")
