class_name SpawnNodeToTile extends Node

@onready var tilemap: TileMapLayer = get_parent()
@export var node_scene: PackedScene
@export var tile_source: int = 0
@export var tile_index: Array[Vector2i] = []

func _ready() -> void:
	if !tilemap || !node_scene:
		return

	for coords in tile_index.size():
		var tiles: Array[Vector2i] = tilemap.get_used_cells_by_id(tile_source, tile_index[coords])
		for tile in tiles:
			var node_instance = node_scene.instantiate()
			var world_position = tilemap.map_to_local(tile)
			node_instance.global_position = world_position * tilemap.scale.x
			add_child(node_instance)
