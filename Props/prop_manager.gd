extends Node

@onready var game_tree = get_node("/root/GameTree")
var last_placement: Dictionary = {}
const MIN_DISTANCE_BETWEEN_PROPS = 20.0  # pixels
const MIN_TIME_INTERVAL_BETWEEN_PROPS = 0.1  # seconds (100ms)

const PROP_TYPE: Dictionary = {
	&"bullet_dies": {
		"scene": preload("res://Props/BulletDiesProp.tscn"),
		"amount": 10,
		"create_on_demand": false
	},
	&"dust_pound": {
		"scene": preload("res://Props/DustPoundProp.tscn"),
		"amount": 10,
		"create_on_demand": false
	},
	&"dust_jump": {
		"scene": preload("res://Props/DustJumpProp.tscn"),
		"amount": 10,
		"create_on_demand": false
	},
	&"new": {
		"scene": preload("res://Props/NewProp.tscn"),
		"amount": 10,
		"create_on_demand": false
	},
	&"splash": {
		"scene": preload("res://Props/SplashProp.tscn"),
		"amount": 10,
		"create_on_demand": false
	},
	&"puff": {
		"scene": preload("res://Props/PuffProp.tscn"),
		"amount": 10,
		"create_on_demand": false
	}
}

var prop_pools: Dictionary = {}

func _ready():
	for prop_name in PROP_TYPE.keys():
		prop_pools[prop_name] = []
	populate_pools()

func populate_pools():
	for prop_name in PROP_TYPE.keys():
		var amount = PROP_TYPE[prop_name]["amount"]
		for i in range(amount):
			var prop = PROP_TYPE[prop_name]["scene"].instantiate()
			prop.visible = false
			prop.set_meta("prop_name", prop_name)
			game_tree.add_child(prop)
			prop_pools[prop_name].append(prop)

func place_prop(global_pos: Vector2, prop_name: StringName, color_pair: Array[Color] = [], auto_play: bool = true) -> Node2D:
	# Check if we should skip this placement
	var current_time = Time.get_ticks_msec() / 1000.0
	if prop_name in last_placement:
		var last_pos = last_placement[prop_name]["position"]
		var last_time = last_placement[prop_name]["time"]
		if global_pos.distance_to(last_pos) < MIN_DISTANCE_BETWEEN_PROPS\
		and (current_time - last_time) < MIN_TIME_INTERVAL_BETWEEN_PROPS:
			if DebugTools.print_stuff: print("skipped | ", prop_name)
			return null
	
	var prop: Node2D
	
	if prop_pools[prop_name].is_empty():
		if PROP_TYPE[prop_name]["create_on_demand"]:
			prop = PROP_TYPE[prop_name]["scene"].instantiate()
			prop.set_meta("prop_name", prop_name)
			game_tree.add_child(prop)
		else:
			prop = game_tree.get_children().filter(func(child): 
				return child.has_meta("prop_name") and child.get_meta("prop_name") == prop_name
			)[0]
	else:
		prop = prop_pools[prop_name].pop_back()

	prop.global_position = global_pos
	prop.z_index = 1
	if auto_play: prop.play()
	if color_pair.size() == 2: _color_prop(prop, color_pair)
	last_placement[prop_name] = {"position": global_pos, "time": current_time}
	prop.visible = true
	prop.reset_physics_interpolation()

	return prop

func return_prop(prop: Node2D):
	var prop_name = prop.get_meta("prop_name")
	prop.visible = false
	prop_pools[prop_name].append(prop)

func _color_prop(prop: Node2D, color_pair: Array[Color]) -> void:
	for child in prop.get_children():
		if child is BwShaderSetter:
			child.set_color(color_pair[0], color_pair[1])
	
func return_all_props():
	for child in game_tree.get_children():
		if child.has_meta("prop_name"):
			var prop_name = child.get_meta("prop_name")
			if prop_name in prop_pools:
				child.visible = false
				if child not in prop_pools[prop_name]:
					prop_pools[prop_name].append(child)
	last_placement.clear()
