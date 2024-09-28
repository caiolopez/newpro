@tool class_name CameraLocker extends Area2D

enum LockHandles {
	PLACE_OF_CONTACT = 0,	## Centers the camera to the position hero was when this locker was overlapped.
	AREA_CENTER = 1,		## Centers the camera in the middle of the locker object area.
	MARKER_OBJECT = 2			## Centers the camera at a custom position provided by a Marker2D node attached to locker.
	}

const debug_color_x: Color = Color(0, 0, 1, 0.5)
const debug_color_y: Color = Color(1, 0, 0, 0.5)
const debug_color_both: Color = Color(1, 0, 1, 0.5)
@export var axes_to_lock: Constants.Axes:
	get:
		return axes_to_lock
	set(value):
		queue_redraw()
		axes_to_lock = value
@export var center_at: LockHandles = LockHandles.PLACE_OF_CONTACT ## Once locked, where the camera should center.
var center_mark: Marker2D = null

func _ready():
	draw.connect(debug_color_changer)
	if Engine.is_editor_hint():
		child_entered_tree.connect(func(_child): queue_redraw())
	
	for child in get_children():
		if child is Marker2D:
			center_mark = child
			break
	
	body_entered.connect(on_hero_entered_locker)
	body_exited.connect(on_hero_exited_locker)

func on_hero_entered_locker(body: Node2D):
	if not body is Hero: return
	var lock_position: Vector2
	match center_at:
		LockHandles.PLACE_OF_CONTACT:
			lock_position = body.global_position
		LockHandles.AREA_CENTER:
			lock_position = find_collider().global_position
		LockHandles.MARKER_OBJECT:
			lock_position = center_mark.global_position
		
	Events.hero_entered_camera_locker.emit(self, axes_to_lock, lock_position)

func on_hero_exited_locker(body: Node2D):
	if not body is Hero: return
	Events.hero_exited_camera_locker.emit(self, axes_to_lock)

func debug_color_changer():
	var color: Color
	match axes_to_lock:
		Constants.Axes.x: color = debug_color_x
		Constants.Axes.y: color = debug_color_y
		Constants.Axes.both: color = debug_color_both
	for child in get_children():
		if child is CollisionShape2D:
			child.debug_color = color

func find_collider() -> Node2D:
	var collider: Node2D = null
	for c in get_children():
		if c is CollisionShape2D\
		or c is CollisionPolygon2D:
			collider = c
	return collider
