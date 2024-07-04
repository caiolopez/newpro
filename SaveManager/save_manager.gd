extends Node

var hero_persistence: Dictionary = {}
var entity_persistence: Dictionary = {}
var regions: Dictionary = {}

func add_region_entry(region: Region):
	if not regions.has(region.name):
		regions[region.name] = entity_persistence.duplicate()

func update_entities(key: String, value):
	regions[RegionManager.current_region.name][key] = value

func update_hero(key: String, value):
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
	# TODO: close

func load_file():
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	print(file.get_as_text())
	return file.get_as_text()

func save_parser(data: String):
	var json = JSON.new()
	var error = json.parse(data)
	if error == OK:
		var data_received = json.data
		if typeof(data_received) == TYPE_DICTIONARY:
			print(data_received)
		else:
			print("Unexpected data")
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", data, " at line ", json.get_error_line())


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
