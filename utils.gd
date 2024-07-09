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


func paint_white(active: bool, target: CanvasItem, duration: float = 0.0):
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


func create_blinking_timer(target: Node2D, duration: float = 0.8, auto_stop_time: float = 0.5) -> Timer:
	var og_mod: Color = target.modulate
	
	var timer = Timer.new()
	target.add_child(timer)
	timer.wait_time = duration
	timer.timeout.connect(func() -> void:
		if target.modulate == Color.TRANSPARENT:
			target.modulate = og_mod
		else:
			target.modulate = Color.TRANSPARENT)
	timer.start()
	timer.tree_exiting.connect(func():
		target.modulate = og_mod)

	if auto_stop_time > 0:
		var auto_stop_timer = Timer.new()
		target.add_child(auto_stop_timer)
		auto_stop_timer.wait_time = auto_stop_time
		auto_stop_timer.one_shot = true
		auto_stop_timer.timeout.connect(func():
			timer.queue_free()
			auto_stop_timer.queue_free())
		auto_stop_timer.start()

	return timer

func is_pushing_sides() -> bool:
	return Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right")

func find_hero() -> Hero:
	var hero: Hero = null
	if get_tree().get_nodes_in_group("heroes").is_empty():
		push_warning("Could not locate Hero within tree.")
	else:
		hero = get_tree().get_first_node_in_group("heroes")
	return hero

func get_ancestors(node: Node) -> Array:
	var ancestors = []
	var current_node = node
	while current_node.get_parent() != null:
		current_node = current_node.get_parent()
		ancestors.append(current_node)
	return ancestors

func parse_time_as_string(time: float, colon_separated: bool = true) -> String:
	var h = int(time / 3600)
	var m = int(time / 60) % 60
	var s = int(time) % 60
	var ms = int((time - floor(time)) * 1000)
	if colon_separated:
		return "%02d:%02d:%02d:%03d" % [h, m, s, ms]
	else:
		return "%02dh%02d'%02d.%03d\"" % [h, m, s, ms]
