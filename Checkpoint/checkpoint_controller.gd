@tool
class_name CheckpointController extends Area2D

@export_tool_button("Make all unique") var v = make_all_collision_shapes_unique

func _ready():
	body_shape_entered.connect(_on_body_shape_entered)

func _on_body_shape_entered(_rid, body, _body_shape, area_shape_index):
	if not body is Hero and not body.state_machine.current_state.death_prone:
		return
	var cp: CheckpointTrigger = get_collision_shape_by_index(area_shape_index)
	var direction: int = cp.direction
	if body.current_checkpoint_path == cp.get_path() and not cp.always_trigger:
		return
	if not direction:
		direction = body.facing_direction
		
	body.update_current_checkpoint_info(cp.get_path(), direction)
	Events.hero_reached_checkpoint.emit()
	await get_tree().process_frame
	SaveManager.save_file()

func get_collision_shape_by_index(shape_index: int) -> CheckpointTrigger:
	var shapes = get_children().filter(func(node): return node is CheckpointTrigger)
	if shape_index >= 0 and shape_index < shapes.size():
		return shapes[shape_index]
	return null

func make_all_collision_shapes_unique() -> void:
	for shape in get_children().filter(func(node): return node is CheckpointTrigger):
		print("Made ", shape, " unique.")
		shape.shape = shape.shape.duplicate()
