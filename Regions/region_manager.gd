extends Node

var current_region: Region

func change_region(to_region: Constants.RegName) -> void:
	if current_region:
		var save_path = "user://Regions/" + Constants.RegName.keys()[current_region.region_name] + ".tscn"
		Utils.save_node(current_region, save_path)
		current_region.queue_free()
	
	var load_path = "user://Regions/" + Constants.RegName.keys()[to_region] + ".tscn"
	var loaded_node = Utils.load_node(load_path)
	
	if loaded_node:
		add_child(loaded_node)
		current_region = loaded_node
		print(loaded_node, " loaded.")
	else:
		print("Requested serialized region not found. Instantiating brand new one.")
		var new_region = load("res://Regions/" + Constants.RegName.keys()[to_region] + ".tscn").instantiate()
		if new_region:
			add_child(new_region)
			current_region = new_region
			print("New ", Constants.RegName.keys()[to_region], " region instantiated. Current region is now " + Constants.RegName.keys()[current_region.region_name], ".")
		else:
			print("Could not isntantiate new ", Constants.RegName.keys()[to_region], ".") 

func _process(_delta):
	pass
	#if Input.is_action_just_pressed("up"):
		#change_region(Constants.RegName.HUB)
