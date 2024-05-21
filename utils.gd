extends Node


func test():
	print("test")
	
func make_collision_shape_unique(col: CollisionShape2D):

	var original_shape = col.shape
	if original_shape == null: return
	var cloned_shape = original_shape.duplicate()
	col.shape = cloned_shape
	print("Generated unique shape for ", col)


func dt_lerp(delta: float, ratio: float) -> float:
	if delta < 0 or ratio < 0:
		push_error("Delta and ratio should be non-negative")
		return -1.0
	var dt_lerp = 1 - pow(0.5, delta * ratio)
	return clamp(dt_lerp, 0.0, 1.0)

func find_dmg_taker(node: Node) -> DmgTaker:
	var dmg_taker: DmgTaker
	for child in node.get_children():
		if child is DmgTaker:
			dmg_taker = child
			break
	return dmg_taker
		
