@tool
class_name _SmartArea2D extends Area2D

## Automatically make CollisionShape2D.shape resources unique upon duplication in the editor. Does so to reduce error proneness when resizing colliders of cloned nodes.

@export_tool_button("Make all unique") var v = _make_all_collision_shapes_unique ## Makes all CollisionShape2D.shape resources unique.

func _init():
	if Engine.is_editor_hint():
		child_entered_tree.connect(_make_collision_shape_unique)
		set_meta("init_time", Time.get_ticks_msec())
		queue_redraw()

func _make_all_collision_shapes_unique() -> void:
	var count: int = 0
	for shape in get_children().filter(func(node): return node is CollisionShape2D):
		count += 1
		shape.shape = shape.shape.duplicate()
	if count: print(count, " shapes were made unique by ", self.name)

func _make_collision_shape_unique(node) -> void:
	if not node is CollisionShape2D: return
	if Time.get_ticks_msec() - get_meta("init_time") < 1000: return
	node.shape = node.shape.duplicate()
	print(node.name, " shape was made unique by ", self.name)
