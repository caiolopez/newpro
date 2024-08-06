extends Node2D

@onready var game_tree = get_node("/root/GameTree")

const PROP_TYPE: Dictionary = {
	&"bullet_dies": {
		"scene": preload("res://Props/BulletDiesProp.tscn"),
		"amount": 10,
		"create_on_demand": false
	},
	&"dust_floor": {
		"scene": preload("res://Props/DustFloorProp.tscn"),
		"amount": 10,
		"create_on_demand": false
	},
	&"dust2": {
		"scene": preload("res://Props/Dust2Prop.tscn"),
		"amount": 10,
		"create_on_demand": false
	},
	&"splash": {
		"scene": preload("res://Props/SplashProp.tscn"),
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

func place_prop(global_pos: Vector2, prop_name: StringName, auto_play: bool = true) -> Node2D:
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
	
	prop.visible = true
	prop.global_position = global_pos
	if auto_play: prop.play()
	return prop

func return_prop(prop: Node2D):
	var prop_name = prop.get_meta("prop_name")
	prop.visible = false
	prop_pools[prop_name].append(prop)
