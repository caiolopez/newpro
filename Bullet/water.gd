class_name Water extends Area2D

func get_surface_global_position() -> float:
	return (global_position - (get_node("CollisionShape2D").shape.extents * scale)).y
