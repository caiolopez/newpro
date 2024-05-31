extends Node


func make_collision_shape_unique(col: CollisionShape2D):

	var original_shape = col.shape
	if original_shape == null: return
	var cloned_shape = original_shape.duplicate()
	col.shape = cloned_shape
	print("Generated unique shape for ", col)


func dt_lerp(speed: float, delta: float) -> float:
	if delta < 0 or speed < 0:
		push_error("Delta and ratio should be non-negative")
		return -1.0
	var dtlerp = 1 - pow(0.5, delta * speed)
	return clamp(dtlerp, 0.0, 1.0)


func find_dmg_taker(node: Node) -> DmgTaker:
	var dmg_taker: DmgTaker = null
	for child in node.get_children():
		if child is DmgTaker:
			dmg_taker = child
			break
	return dmg_taker


func disconnect_all(sig: Signal):
	for connection in sig.get_connections():
		sig.disconnect(connection["callable"])
