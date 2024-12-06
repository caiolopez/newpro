class_name MiniMap extends Control

@export var minimum_scale: float = 0.1
@export var maximum_scale: float = 0.3
var min_scale: Vector2:
	get: return Vector2(minimum_scale, minimum_scale)
var max_scale: Vector2:
	get: return Vector2(maximum_scale, maximum_scale)
@onready var mini_hero: Sprite2D = $Icons/MiniHero
var waypoint_scene = load("res://GUI/Waypoint.tscn")
var default_scale: float = 0.1
var scale_speed: Vector2 = Vector2(2.5, 2.5)
var move_speed: Vector2 = Vector2(1000, 1000)

var top_bound: float = INF;
var bottom_bound: float = -INF;
var left_bound: float = INF;
var right_bound: float = -INF;
var bound_padding: Vector2 = Vector2(100, 100)

var map_flags: Array[Node2D] = []
enum States {ON, ANIMATING_IN, ANIMATING_OUT, OFF}
var state: States = States.OFF

func _ready() -> void:
	AppManager.minimap_node = self # self-registration
	Events.chart_map_sector.connect(append_sector_to_map)
	Events.unchart_map_sector.connect(delete_sector_from_map)
	Events.hero_reached_checkpoint.connect(update_to_dictionary)
	
	SaveManager.game_loaded_from_disk.connect(update_from_dictionary)
	
	$SectorPolygons.self_modulate = Color.TRANSPARENT
	$Icons.self_modulate = Color.TRANSPARENT
	adjust_icon_scale()

func append_sector_to_map(sect_coll: MapSectorTrigger):
	
	var new_mini_sector = SectorPolygon.new()
	new_mini_sector.ref = sect_coll.get_path()
	new_mini_sector.polygon = sect_coll.polygon
	new_mini_sector.global_position = sect_coll.global_position
	$SectorPolygons.add_child(new_mini_sector)

func delete_sector_from_map(sector_path: NodePath):
	for poly in $SectorPolygons.get_children():
		if poly is SectorPolygon and poly.ref == sector_path:
			poly.queue_free()

func update_mini_hero_pos():
	mini_hero.position = AppManager.hero.global_position

func center_map():
	update_mini_hero_pos()
	position = Vector2.ZERO - mini_hero.position * scale + get_viewport_rect().size / 2
	set_bounds()

func adjust_scale(delta, direction):
	var old_scale = scale
	scale += direction * scale_speed * delta
	var scale_factor = scale / old_scale
	position = (position - get_viewport_rect().size / 2) * scale_factor + get_viewport_rect().size / 2
	adjust_icon_scale()

func flag_minimap():
	var new_flag
	if map_flags.size() < 1:
		new_flag = waypoint_scene.instantiate()
		$Icons.add_child(new_flag)
		map_flags.append(new_flag)
	else:
		new_flag = map_flags.pop_front()
		map_flags.append(new_flag)
	new_flag.position = (get_viewport_rect().size / 2 - position) / scale
	adjust_icon_scale()

func adjust_icon_scale():
	for child in $Icons.get_children():
		child.scale = Vector2.ONE / scale

func show_minimap() -> bool:
	if state == States.OFF:
		center_map()
		_fade_in_minimap()
		state = States.ANIMATING_IN
		return true
	return false

func hide_minimap():
	if state == States.ON:
		_fade_out_minimap()
		state = States.ANIMATING_OUT
		return true
	return false

func _process(delta):
	if state == States.ANIMATING_IN:
		if scale > min_scale:
			adjust_scale(delta, -1)
		else:
			state = States.ON
		update_mini_hero_pos()
		return

	if state == States.ANIMATING_OUT:
		update_mini_hero_pos()
		return

	if state == States.ON:
		handle_actions(delta)
		set_bounds()

func handle_actions(delta):
	if Input.is_action_pressed("up") and position.y + bottom_bound * scale.y > bound_padding.y:
		position.y -= move_speed.y * delta
	if Input.is_action_pressed("down") and position.y + top_bound * scale.y < get_viewport_rect().size.y - bound_padding.y:  
		position.y += move_speed.y * delta
	if Input.is_action_pressed("left") and position.x + right_bound * scale.x > bound_padding.x:  
		position.x -= move_speed.x * delta
	if Input.is_action_pressed("right") and position.x + left_bound * scale.x < get_viewport_rect().size.x - bound_padding.x: 
		position.x += move_speed.x * delta

	#if Input.is_action_pressed("shoulder_left") and scale > min_scale:
	#	adjust_scale(delta, -1)
	#if Input.is_action_pressed("shoulder_right") and scale < max_scale:
	#	adjust_scale(delta, 1)

	if Input.is_action_just_pressed("center_map"):
		center_map()
	if Input.is_action_just_pressed("flag_minimap"):
		flag_minimap()

func set_bounds():
	var top = INF
	var bottom = -INF
	var left = INF
	var right = -INF
	
	for sector in $SectorPolygons.get_children():
		var extents = Utils.get_polygon_extents(sector.polygon);
		var pos = extents.position + sector.position
		var map_size = extents.size
		
		var polygon_top = pos.y
		var polygon_bot = pos.y + map_size.y
		var polygon_left = pos.x
		var polygon_right = pos.x + map_size.x
		
		if polygon_top < top:
			top = polygon_top
		if polygon_bot > bottom:
			bottom = polygon_bot
		if polygon_left < left:
			left = polygon_left
		if polygon_right > right:
			right = polygon_right
	
	top_bound = top
	bottom_bound = bottom
	left_bound = left
	right_bound = right

func _fade_in_minimap():
	var t = create_tween()
	t.tween_property($SectorPolygons, "self_modulate", Color.CORNFLOWER_BLUE, 0.5)
	t.parallel().tween_property($Icons, "self_modulate", Color.WHITE, 0.5)

func _fade_out_minimap():
	var t = create_tween()
	t.tween_property($SectorPolygons, "self_modulate", Color.TRANSPARENT, 0.25)
	t.parallel().tween_property($Icons, "self_modulate", Color.TRANSPARENT, 0.25)
	t.tween_callback(func():
		state = States.OFF
		scale = Vector2.ONE)

func update_to_dictionary():
	SaveManager.minimap = {
		"sectors": serialize_sectors(),
		"flags": serialize_flags(),
	}

func serialize_sectors() -> Array:
	var serialized_sectors = []
	for sector in $SectorPolygons.get_children():
		if sector is SectorPolygon:
			serialized_sectors.append({
				"polygon": var_to_str(sector.polygon),
				"position": var_to_str(sector.position),
				"reference":  var_to_str(sector.ref)
			})
	return serialized_sectors

func serialize_flags() -> Array:
	var serialized_flags = []
	for flag in map_flags:
		serialized_flags.append({
			"position": var_to_str(flag.position)
		})
	return serialized_flags

func update_from_dictionary():
	var data: Dictionary = SaveManager.minimap
	
	for child in $SectorPolygons.get_children():
		child.queue_free()
	for flag in map_flags:
		flag.queue_free()
	map_flags.clear()
	
	if "sectors" in data:
		for sector_data in data["sectors"]:
			var new_mini_sector = SectorPolygon.new()
			new_mini_sector.polygon = str_to_var(sector_data["polygon"])
			new_mini_sector.global_position = str_to_var(sector_data["position"])
			new_mini_sector.ref = str_to_var(sector_data["reference"])
			$SectorPolygons.add_child(new_mini_sector)
	
	if "flags" in data:
		for flag_data in data["flags"]:
			var new_flag = waypoint_scene.instantiate()
			new_flag.position = str_to_var(flag_data["position"])
			$Icons.add_child(new_flag)
			map_flags.append(new_flag)

func reset():
	for child in $SectorPolygons.get_children():
		child.queue_free()

	for flag in map_flags:
		flag.queue_free()
	map_flags.clear()

	top_bound = INF
	bottom_bound = -INF
	left_bound = INF
	right_bound = -INF
