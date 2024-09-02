class_name Water extends Area2D

var collider: CollisionShape2D

func _ready() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			collider = child

func get_surface_global_position() -> float:
	var shape_extents = collider.shape.extents
	return collider.global_position.y - shape_extents.y
