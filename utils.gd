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

func get_animation_frame_count(animated_sprite: AnimatedSprite2D, anim_name: StringName) -> int:
	var frames = animated_sprite.sprite_frames
	return frames.get_frame_count(anim_name) if frames and frames.has_animation(anim_name) else 0

func randomize_animation_frame(animated_sprite: AnimatedSprite2D, anim_name: StringName = &""):
	if anim_name == &"":
		anim_name = animated_sprite.animation
	animated_sprite.frame = randi_range(0, get_animation_frame_count(animated_sprite, anim_name))

func colorize_silhouette(active: bool, target: CanvasItem, duration: float = 0.0, color: Color = Color.WHITE):
	var silhouette_material: ShaderMaterial = preload("res://CaioShaders/silhouette.tres")
	if active:
		if duration > 0.0:
			var timer = Timer.new()
			target.add_child(timer)
			timer.wait_time = duration
			timer.one_shot = true
			timer.timeout.connect(func() -> void:
				timer.queue_free()
				colorize_silhouette(false, target, 0.0))
			timer.start()
		silhouette_material.set_shader_parameter("custom_color", color)
		target.material = silhouette_material
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

func get_polygon_extents(points: PackedVector2Array) -> Rect2:
	var min_x = INF
	var max_x = -INF
	var min_y = INF
	var max_y = -INF

	for point in points:
		min_x = min(min_x, point.x)
		max_x = max(max_x, point.x)
		min_y = min(min_y, point.y)
		max_y = max(max_y, point.y)

	return Rect2(Vector2(min_x, min_y), Vector2(max_x - min_x, max_y - min_y))

func fade_in(node: CanvasItem, duration: float = 1.0) -> Tween:
	_kill_existing_fade_tween(node)
	node.modulate.a = 0
	node.show()
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, duration)
	tween.finished.connect(func(): _clean_up_tween(node))
	node.set_meta("fade_tween", tween)
	return tween

func fade_out(node: CanvasItem, duration: float = 1.0) -> Tween:
	_kill_existing_fade_tween(node)
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0.0, duration)
	tween.tween_callback(node.hide)
	tween.finished.connect(func(): _clean_up_tween(node))
	node.set_meta("fade_tween", tween)
	return tween

func _kill_existing_fade_tween(node: CanvasItem):
	if node.has_meta("fade_tween"):
		var existing_tween = node.get_meta("fade_tween")
		if existing_tween.is_valid():
			existing_tween.kill()
		_clean_up_tween(node)

func _clean_up_tween(node: CanvasItem):
	if node.has_meta("fade_tween"):
		node.remove_meta("fade_tween")

func lose_focus():
	var focused_node = get_viewport().gui_get_focus_owner()
	if focused_node:
		focused_node.release_focus()

func get_collision_shape_by_index(parent_area: Area2D, shape_index: int) -> CollisionShape2D:
	var shapes = parent_area.get_children().filter(func(node): return node is CollisionShape2D)
	if shape_index >= 0 and shape_index < shapes.size():
		return shapes[shape_index]
	return null

func get_collision_polygon_by_index(parent_area: Area2D, shape_index: int) -> CollisionPolygon2D:
	var shapes = parent_area.get_children().filter(func(node): return node is CollisionPolygon2D)
	if shape_index >= 0 and shape_index < shapes.size():
		return shapes[shape_index]
	return null
