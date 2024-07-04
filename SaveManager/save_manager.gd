extends Node

var hero_persistence: Dictionary = {}
var regions: Dictionary = {}

func add_region_entry(region: Region):
	if not regions.has(region.name):
		regions[region.name] = {}

func log_entity_change(key: String, value):
	regions[RegionManager.current_region.name][key] = value

func log_hero_change(key: String, value):
	hero_persistence[key] = value

func save_file():
	var save = {"hero_changes": hero_persistence, "entity_changes": regions}
	var json_string = JSON.stringify(save)
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	if file:
		file.store_string(json_string)
		print("Saved.")
	else:
		print("Error saving game: ", FileAccess.get_open_error())

func load_file():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var data = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(data)
	if error == OK:
		if typeof(json.data) == TYPE_DICTIONARY: print(json.data)
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data, " at line ", json.get_error_line())

	hero_persistence = json.data["hero_changes"]
	regions = json.data["entity_changes"]

func inject_changes_into_current_region():
	var changes = regions[RegionManager.current_region]
	# TODO

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
