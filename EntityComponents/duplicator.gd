extends Node

func self_duplicate(relative_pos: Vector2 = Vector2.ZERO) -> Node2D:
	var parent = get_parent()
	var clone = parent.duplicate()
	clone.position = parent.position + relative_pos
	parent.get_parent().add_child(clone)
	return clone
