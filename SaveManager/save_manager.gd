extends Node

var hero_persistence: Dictionary = {}
var regions: Dictionary = {}
var minimap: Dictionary = {}
var current_slot: int

signal game_loaded_from_disk
signal game_saved_to_disk

func _ready():
	ComboParser.combo_performed.connect(func(combo):
		if combo == "SaveCurrentGame": save_file()
		)
	ComboParser.combo_performed.connect(func(combo):
		if combo == "LoadCurrentGame":
			if load_from_slot():
				AppManager.game_started.emit()
			)

func add_region_entry(region: Region):
	if not regions.has(region.name):
		regions[region.name] = {}
		if DebugTools.print_stuff: print("region entry added for ", region.name)

func log_entity_change(entity: Node, value):
	var from_region: Region = RegionManager.get_region_from_node(entity)
	if not from_region:
		push_warning(entity.name, " has no region. Log to dictionary aborted.")
		return
	add_region_entry(from_region)
	var key: NodePath = entity.get_path()
	if from_region and key and value:
		regions[from_region.name][key] = value
	else:
		if DebugTools.print_stuff: print("logging ", entity.name, "'s ", key, " as ", value, " failed.")

func log_hero_change(key: String, value):
	hero_persistence[key] = value

func save_file():
	if RegionManager.current_region:
		hero_persistence["current_region"] = RegionManager.current_region.name
	hero_persistence["elapsed_time"] = AppManager.game_time
	
	var save = {
		"hero_changes": hero_persistence,
		"entity_changes": regions,
		"minimap": minimap
	}
	var json_string = JSON.stringify(save, "\t")
	var file = FileAccess.open("user://save_" + str(current_slot) + ".dat", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		if DebugTools.print_stuff: print("Saved.")
		game_saved_to_disk.emit()
	else:
		if DebugTools.print_stuff: print("Error saving game: ", FileAccess.get_open_error())

func load_file() -> bool:
	var file = FileAccess.open("user://save_" + str(current_slot) + ".dat", FileAccess.READ)
	if file == null:
		if DebugTools.print_stuff: print("File: user://save_" + str(current_slot) + ".dat does not exist.")
		return false

	var data = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(data)
	if error != OK:
		if DebugTools.print_stuff: print("JSON Parse Error: ", json.get_error_message(), " in ", data, " at line ", json.get_error_line())
		return false

	if typeof(json.data) != TYPE_DICTIONARY:
		if DebugTools.print_stuff: print("Parsed JSON is not a dictionary")
		return false

	if not json.data.has_all(["hero_changes", "entity_changes", "minimap"]):
		if DebugTools.print_stuff: print("Save file is missing required data")
		return false

	hero_persistence = json.data["hero_changes"]
	regions = json.data["entity_changes"]
	minimap = json.data["minimap"]

	if DebugTools.print_stuff: print("File loaded successfully")
	return true

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
						"interacted":
							if has_node(key):
								get_node(key).set_as_interacted()

func inject_changes_into_hero():
	var h = Utils.find_hero()
	for key in hero_persistence:
		var value = hero_persistence[key]
		match key:
			"current_checkpoint_path": h.current_checkpoint_path = value
			"got_incendiary_ammo": h.shooter.bullet_type = Constants.BulletType.FIRE
			"got_underwater_ammo": h.shooter.shoots_underwater_ammo = value
			"got_aqualung": h.can_dive = value
			"got_teleporter": AppManager.teleporters_are_active = value
			"elapsed_time": AppManager.game_time = value
			"current_region":
				if Constants.RegName.get(value):
					RegionManager.change_region(Constants.RegName.get(value))
				else:
					push_warning("Current region ", value, " not in Constants.RegName. change_region() failed.")

func load_from_slot(slot: int = current_slot) -> bool:
	current_slot = slot
	if not load_file():
		return false
	inject_changes_into_hero()
	inject_changes_into_regions()
	game_loaded_from_disk.emit()
	if DebugTools.print_stuff: print("Game loaded from slot ", slot, ".")
	return true

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

func has_valid_save_file(slot: int = current_slot) -> bool:
	var file_path = "user://save_" + str(slot) + ".dat"
	if not FileAccess.file_exists(file_path):
		return false
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		return false

	var data = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(data)

	if error != OK or typeof(json.data) != TYPE_DICTIONARY:
		return false
	
	var required_keys = ["hero_changes", "entity_changes", "minimap"]
	for key in required_keys:
		if not json.data.has(key):
			return false

	return true
