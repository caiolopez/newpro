extends Node


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


func check_if_foe(node: Node) -> bool:
	var is_foe: bool = true

	if "is_foe" in node:
		is_foe = node.is_foe

	for child in node.get_children():
		if child is FriendOrFoe:
			is_foe = child.is_foe
			break

	return is_foe


func disconnect_all(sig: Signal):
	for connection in sig.get_connections():
		sig.disconnect(connection["callable"])


func aprox_equal_vector2(a: Vector2, b: Vector2, tolerance: float = 1.0) -> bool:
	var x = abs(a.x - b.x) < tolerance
	var y = abs(a.y - b.y) < tolerance
	return x and y


func subtract_vector2(a: Vector2, b: Vector2) -> Vector2:
	return Vector2(a.x - b.x, a.y - b.y)


func paint_white(active: bool, target: Node2D, duration: float = 0.0):
	var white_material: ShaderMaterial = preload("res://CaioShaders/white.tres")
	if active:
		if duration > 0.0:
			var timer = Timer.new()
			target.add_child(timer)
			timer.wait_time = duration
			timer.one_shot = true
			timer.timeout.connect(func() -> void:
				timer.queue_free()
				paint_white(false, target, 0.0))
			timer.start()
		target.material = white_material
	else:
		target.material = null
		if "original_material" in target:
			target.material = target.original_material


func is_pushing_sides() -> bool:
	return Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")


func get_hero_glpos() -> Vector2:
	if not get_tree().get_nodes_in_group("heroes").is_empty():
		return get_tree().get_nodes_in_group("heroes")[0].global_position
	else:
		push_error("Hero not found in Utils.get_hero_glpos(). global_position defaulted to Vector2.ZERO")
		return Vector2.ZERO
