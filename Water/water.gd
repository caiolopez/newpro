class_name Water extends Area2D

var bw_shader_setter: BwShaderSetter
var collider: CollisionShape2D
var is_movable: bool = false ## When set to true, causes hero to update surface information frequently.
@onready var tile_map_layer: TileMapLayer = $TileMapLayer

func _ready() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			collider = child
		if child is BwShaderSetter:
			bw_shader_setter = child
	
	if tile_map_layer and collider:
		_setup_water_surface_art()

func get_surface_global_position() -> float:
	var shape_extents = collider.shape.extents
	return collider.global_position.y - shape_extents.y

func _setup_water_surface_art() -> void:
	var fine_tune: Vector2 = Vector2(0, -50)
	
	var shape_extents = collider.shape.extents
	var tile_size = tile_map_layer.tile_set.tile_size.x * tile_map_layer.scale.x
	var num_tiles = ceil(shape_extents.x * 2 / tile_size)
	tile_map_layer.position = collider.position - shape_extents + fine_tune
	for i in range(num_tiles):
		var tile_pos = Vector2i(i, 0)
		tile_map_layer.set_cell(tile_pos, 0, Vector2i.ZERO, 0)
	tile_map_layer.update_internals()
