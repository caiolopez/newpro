class_name Water extends Area2D

var bw_shader_setter: BwShaderSetter
var collider: CollisionShape2D
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			collider = child
		if child is BwShaderSetter:
			bw_shader_setter = child
	
	if tile_map_layer and collider:
		setup_water_surface()

func get_surface_global_position() -> float:
	var shape_extents = collider.shape.extents
	return collider.global_position.y - shape_extents.y

func setup_water_surface() -> void:
	var tile_map_scale = tile_map_layer.scale.x
	if not tile_map_layer.tile_set:
		printerr("TileSet not set for water surface TileMapLayer")
		return

	# Apply scale to TileMapLayer
	tile_map_layer.scale = Vector2(tile_map_scale, tile_map_scale)

	# Calculate the number of tiles needed
	var shape_extents = collider.shape.extents
	var tile_size = tile_map_layer.tile_set.tile_size * tile_map_scale
	var num_tiles = ceil(shape_extents.x * 2 / tile_size.x)

	# Calculate the starting position
	var start_pos = Vector2(
		collider.position.x - shape_extents.x,
		collider.position.y - shape_extents.y
	)
	var map_start_pos = tile_map_layer.local_to_map(start_pos / tile_map_scale)

	# Place the animated water surface tiles
	for i in range(num_tiles):
		var tile_pos = Vector2i(map_start_pos.x + i, map_start_pos.y)
		tile_map_layer.set_cell(tile_pos, 0, Vector2i(0, 0), 0)

	# Update the TileMapLayer
	tile_map_layer.update_internals()
