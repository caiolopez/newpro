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
var move_speed: Vector2 = Vector2(400, 400)
var map_flags: Array[Node2D] = []
enum States {ON, ANIMATING_IN, ANIMATING_OUT, OFF}
var state: States = States.OFF

func _ready():
	Events.chart_map_sector.connect(append_sector_to_map)
	Events.unchart_map_sector.connect(delete_sector_from_map)
	$SectorPolygons.self_modulate = Color.TRANSPARENT
	$Icons.self_modulate = Color.TRANSPARENT
	adjust_icon_scale()
	center_map()

func append_sector_to_map(sector: MapSector):
	var sect_coll = sector.extract_coll_polygon_2d()
	
	var new_mini_sector = SectorPolygon.new()
	new_mini_sector.ref = sector
	new_mini_sector.polygon = sect_coll.polygon
	new_mini_sector.global_position = sect_coll.global_position
	$SectorPolygons.add_child(new_mini_sector)

func delete_sector_from_map(sector: MapSector):
	for poly in $SectorPolygons.get_children():
		if poly is SectorPolygon and poly.ref == sector:
			poly.queue_free()

func update_mini_hero_pos():
	mini_hero.position = Utils.find_hero().global_position

func center_map():
	update_mini_hero_pos()
	position = Vector2.ZERO - mini_hero.position * scale + get_viewport_rect().size / 2

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

func _process(delta):
	if state == States.OFF\
	and Input.is_action_just_pressed("pause"):
		center_map()
		fade_in_minimap()
		state = States.ANIMATING_IN
		return
	
	if state == States.ANIMATING_IN:
		if scale > min_scale:
			adjust_scale(delta, -1)
		else:
			state = States.ON
		update_mini_hero_pos()
		return
	
	if state == States.ANIMATING_OUT:
		if scale < Vector2.ONE:
			adjust_scale(delta, 1)
		else:
			state = States.OFF
		update_mini_hero_pos()
		return
	
	if state != States.ON:
		return

	update_mini_hero_pos()
	if Input.is_action_pressed("up"):    position.y -= move_speed.y * delta
	if Input.is_action_pressed("down"):  position.y += move_speed.y * delta
	if Input.is_action_pressed("left"):  position.x -= move_speed.x * delta
	if Input.is_action_pressed("right"): position.x += move_speed.x * delta

	if Input.is_action_pressed("shoulder_left"): if scale > min_scale: adjust_scale(delta, -1)
	if Input.is_action_pressed("shoulder_right"): if scale < max_scale: adjust_scale(delta, 1)

	if Input.is_action_just_pressed("center_map"): center_map()
	if Input.is_action_just_pressed("flag_minimap"): flag_minimap()
	
	if Input.is_action_just_pressed("unpause"):
		fade_out_minimap()
		state = States.ANIMATING_OUT

func fade_in_minimap():
	var t = create_tween()
	t.tween_property($SectorPolygons, "self_modulate", Color.CORNFLOWER_BLUE, 0.5)
	t.parallel().tween_property($Icons, "self_modulate", Color.WHITE, 0.5)

func fade_out_minimap():
	var t = create_tween()
	t.tween_property($SectorPolygons, "self_modulate", Color.TRANSPARENT, 0.25)
	t.parallel().tween_property($Icons, "self_modulate", Color.TRANSPARENT, 0.25)
