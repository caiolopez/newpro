@tool
class_name CheckpointController extends Area2D

@export_tool_button("Make all unique") var v = _make_all_collision_shapes_unique

func _init():
	if Engine.is_editor_hint():
		child_entered_tree.connect(_make_collision_shape_unique)
		set_meta("init_time", Time.get_ticks_msec())

func _ready():
	body_shape_entered.connect(_on_body_shape_entered) 

func _on_body_shape_entered(_rid, body: Node2D, _body_shape, area_shape_index: int):
	if not body is Hero and not body.state_machine.current_state.death_prone:
		return
	var cp: CheckpointTrigger = Utils.get_collision_shape_by_index(self, area_shape_index)
	var direction: int = cp.direction
	if body.current_checkpoint_path == cp.get_path() and not cp.always_trigger:
		return
	if not direction:
		direction = body.facing_direction
		
	body.update_current_checkpoint_info(cp.get_path(), direction)
	Events.hero_reached_checkpoint.emit()
	await get_tree().process_frame
	SaveManager.save_file()

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
