@tool
class_name CameraTrigger extends CollisionShape2D

## Must be inside a CameraLockerController node in order to work.

@export var axes_to_lock: Constants.Axes:
	get:
		return axes_to_lock
	set(value):
		axes_to_lock = value
		if Engine.is_editor_hint():
			debug_color_changer()
			get_parent().queue_redraw()

@export var center_at: CameraLockerController.LockHandles = CameraLockerController.LockHandles.PLACE_OF_CONTACT
var center_mark: Marker2D = null

func _ready() -> void:
	for child in get_children():
		if child is Marker2D:
			center_mark = child
			break

func debug_color_changer():
	match axes_to_lock:
		Constants.Axes.HORIZONTAL_LOCK: debug_color = Color(0, 0, 1, 0.5)
		Constants.Axes.VERTICAL_LOCK: debug_color = Color(1, 0, 0, 0.5)
		Constants.Axes.FULL_LOCK: debug_color = Color(1, 0, 1, 0.5)
