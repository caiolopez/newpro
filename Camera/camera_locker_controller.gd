@tool
class_name CameraLockerController extends Area2D

enum LockHandles {
	PLACE_OF_CONTACT = 0,   ## Centers the camera to the position hero was when this CameraTrigger was overlapped.
	AREA_CENTER = 1,        ## Centers the camera in the middle of the CameraTrigger collision shape.
	MARKER_OBJECT = 2       ## Centers the camera at a custom position provided by a Marker2D node attached to CameraTrigger.
}

@export_tool_button("Make all unique") var v = _make_all_collision_shapes_unique

func _init():
	if Engine.is_editor_hint():
		child_entered_tree.connect(_make_collision_shape_unique)
		set_meta("init_time", Time.get_ticks_msec())
		queue_redraw()

func _ready():	
	body_shape_entered.connect(_on_body_shape_entered)
	body_shape_exited.connect(_on_body_shape_exited)

func _on_body_shape_entered(_rid, body: Node2D, _body_shape, area_shape_index: int):
	if not body is Hero: return
	var overlapping_trigger = Utils.get_collision_shape_by_index(self, area_shape_index)
	if not overlapping_trigger: return
	
	var lock_position: Vector2
	match overlapping_trigger.center_at:
		LockHandles.PLACE_OF_CONTACT: lock_position = body.global_position
		LockHandles.AREA_CENTER: lock_position = overlapping_trigger.global_position
		LockHandles.MARKER_OBJECT:
			if overlapping_trigger.center_mark:
				lock_position = overlapping_trigger.center_mark.global_position
			else:
				lock_position = overlapping_trigger.global_position

	Events.hero_entered_camera_locker.emit(overlapping_trigger, overlapping_trigger.axes_to_lock, lock_position)

func _on_body_shape_exited(_rid, body: Node2D, _body_shape, area_shape_index: int):
	if not body is Hero: return
	var exited_trigger = Utils.get_collision_shape_by_index(self, area_shape_index)
	if exited_trigger:
		Events.hero_exited_camera_locker.emit(exited_trigger, exited_trigger.axes_to_lock)

func _make_all_collision_shapes_unique(_node) -> void:
	var count: int = 0
	for shape in get_children().filter(func(node): return node is CollisionShape2D):
		count += 1
		shape.shape = shape.shape.duplicate()
	if count and DebugTools.print_stuff: print(count, " shapes were made unique by ", self.name)

func _make_collision_shape_unique(node) -> void:
	if not node is CollisionShape2D: return
	if Time.get_ticks_msec() - get_meta("init_time") < 1000: return
	node.shape = node.shape.duplicate()
	if DebugTools.print_stuff: print(node.name, " shape was made unique by ", self.name)
