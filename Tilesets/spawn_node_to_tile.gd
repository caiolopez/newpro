class_name SpawnNodeToTile extends Node2D

@onready var tilemap: TileMapLayer = get_parent()
@export var node_scene: PackedScene
@export var tile_source: int = 0
@export var tile_index: Array[Vector2i] = []
@export var spawn_to: Node = null
@export var add_remote_transforms: bool = false
@export var remote_transform_scale: Vector2 = Vector2(0.2, 0.2) ## Because with scale a lot of stuff by 5, we need to "downscale" RemoteTransform2D nodes

func _ready() -> void:
	if !tilemap || !node_scene || !spawn_to:
		return

	for coords in tile_index.size():
		var tiles: Array[Vector2i] = tilemap.get_used_cells_by_id(tile_source, tile_index[coords])
		for tile in tiles:
			var node_instance = node_scene.instantiate()
			var world_position = tilemap.map_to_local(tile)
			node_instance.global_position = world_position * tilemap.scale.x
			spawn_to.add_child(node_instance)

			if add_remote_transforms:
				var remote_transform: RemoteTransform2D = RemoteTransform2D.new()
				remote_transform.position = world_position
				remote_transform.remote_path = node_instance.get_path()
				remote_transform.scale = remote_transform_scale
				add_child(remote_transform)
