extends Node

func test():
	print("oi")
	
func make_collision_shape_unique(col: CollisionShape2D):

	var original_shape = col.shape
	if original_shape == null: return
	var cloned_shape = original_shape.duplicate()
	col.shape = cloned_shape
