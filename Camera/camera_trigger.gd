@tool
class_name CameraTrigger extends CollisionShape2D

## Must be inside a CameraLockerController node in order to work.

@export var axes_to_lock: Constants.Axes:
	get:
		return axes_to_lock
	set(value):
		axes_to_lock = value
		if Engine.is_editor_hint():
			_debug_color_changer()
			if get_parent():
				get_parent().queue_redraw()

@export var center_at: CameraLockerController.LockHandles = CameraLockerController.LockHandles.PLACE_OF_CONTACT

var currently_dead: bool = false
var center_mark: Marker2D = null

func _ready() -> void:
	if not Engine.is_editor_hint():
		Events.hero_respawned_at_checkpoint.connect(_reset_status)
		Events.hero_reached_checkpoint.connect(_commit_status)

	for child in get_children():
		if child is Marker2D:
			center_mark = child
			break

func _debug_color_changer():
	match axes_to_lock:
		Constants.Axes.HORIZONTAL_LOCK: debug_color = Color(0, 0, 1, 0.5)
		Constants.Axes.VERTICAL_LOCK: debug_color = Color(1, 0, 0, 0.5)
		Constants.Axes.FULL_LOCK: debug_color = Color(1, 0, 1, 0.5)

func set_currently_dead():
	currently_dead = true
	set_deferred("disabled", true)

func _commit_status() -> void:
	if currently_dead:
		SaveManager.log_entity_change(self, "dead")
		queue_free()

func _reset_status() -> void:
	currently_dead = false
	set_deferred("disabled", false)
