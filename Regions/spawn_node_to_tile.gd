class_name SpawnNodeToTile extends Node

@onready var tilemap: TileMapLayer = get_parent()
@export var node_scene: PackedScene
@export var tile_source: int = 0
@export var tile_index: Vector2i = Vector2i(0,0)

func _process(_delta):
	if tilemap and node_scene:
		spawn_at_tile(tile_index, tile_source)

func spawn_at_tile(tile_pos: Vector2i, source: int) -> Node2D:
	if tilemap.get_cell_source_id(tile_pos) == source:
		var instance = node_scene.instantiate() as Node2D
		var world_pos = tilemap.map_to_local(tile_pos)
		instance.global_position = world_pos
		add_child(instance)
		return instance
	
	return null
