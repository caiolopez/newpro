class_name MiniMap extends Control

@export var minimum_scale: float = 0.1
@export var maximum_scale: float = 0.3
var min_scale: Vector2:
	get: return Vector2(minimum_scale, minimum_scale)
var max_scale: Vector2:
	get: return Vector2(maximum_scale, maximum_scale)
@onready var mini_hero: Sprite2D = $MiniHero
var default_scale: float = 0.1
var scale_speed: Vector2 = Vector2(1, 1)
var move_speed: Vector2 = Vector2(400, 400)
var map_flags: Array[Node2D] = []
enum States {ON, ANIMATING, OFF}
var state: States = States.OFF

func _ready():
	Events.chart_map_sector.connect(append_sector_to_map)
	adjust_icon_scale()
	center_map()

func append_sector_to_map(sector: MapSector):
	var sect_coll = sector.extract_coll_polygon_2d()
	
	var new_mini_sector = Polygon2D.new()
	new_mini_sector.polygon = sect_coll.polygon
	new_mini_sector.global_position = sect_coll.global_position
	$SectorPolygons.add_child(new_mini_sector)

func update_mini_hero_pos():
	mini_hero.position = Utils.find_hero().global_position

func center_map():
	position = Vector2.ZERO - mini_hero.position * scale + get_viewport_rect().size / 2

func adjust_scale(delta, direction):
	var old_scale = scale
	scale += direction * scale_speed * delta
	var scale_factor = scale / old_scale
	position = (position - get_viewport_rect().size / 2) * scale_factor + get_viewport_rect().size / 2
	
	adjust_icon_scale()

func flag_minimap():
	var new_flag
	if map_flags.size() <= 10:
		new_flag = $Waypoint.duplicate()
		add_child(new_flag)
		map_flags.append(new_flag)
	else:
		new_flag = map_flags.pop_front()
		map_flags.append(new_flag)
	new_flag.position = (get_viewport_rect().size / 2 - position) / scale
	for i in range(map_flags.size()):
		map_flags[i].modulate = Color(1, 0, 1, i / float(map_flags.size()))

func adjust_icon_scale():
	return
	for child in get_children():
		if child.is_in_group("map_icons"):
			child.scale = Vector2.ONE / scale

func _process(delta):
	if state == States.OFF\
	and Input.is_action_just_pressed("pause"):
		show_minimap()
		return
	
	if state == States.ANIMATING:
		adjust_icon_scale()
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
		#hide_icons()
		hide_minimap()

func show_minimap():
	state = States.ANIMATING
	var tween = create_tween()
	tween.tween_property(
		self,
		"scale",
		min_scale,
		0.5).set_ease(Tween.EaseType.EASE_IN)
	tween.parallel().tween_property(
		$SectorPolygons,
		"self_modulate",
		Color.WHITE,
		0.5)
	tween.tween_callback(func():
		#show_icons()
		state = States.ON)

func hide_minimap():
	state = States.ANIMATING
	var tween = create_tween()
	tween.tween_property(
		self,
		"scale",
		Vector2.ONE,
		0.5).set_ease(Tween.EaseType.EASE_IN)
	tween.parallel().tween_property(
		$SectorPolygons,
		"self_modulate",
		Color.TRANSPARENT,
		0.5)
	tween.tween_callback(func(): state = States.OFF)

func show_icons():
	for child in get_children():
		if child.is_in_group("map_icons"):
			child.show()

func hide_icons():
	for child in get_children():
		if child.is_in_group("map_icons"):
			child.hide()
