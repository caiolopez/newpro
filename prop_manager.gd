extends Node2D

@onready var game_tree = get_node("/root/GameTree")

const PROP_TYPE: Dictionary = {
	&"bullet_dies": preload("res://Props/BulletDiesProp.tscn"),
	&"dust_floor": preload("res://Props/DustFloorProp.tscn"),
	&"dust2": preload("res://Props/Dust2Prop.tscn"),
	&"splash": preload("res://Props/SplashProp.tscn")
}

func place_prop(global_pos: Vector2, prop_name: StringName) -> Node2D:
	var prop = PROP_TYPE[prop_name].instantiate()
	prop.global_position = global_pos
	game_tree.add_child(prop)
	return prop
