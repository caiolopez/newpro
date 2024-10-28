extends Area2D

func _ready():
	body_shape_entered.connect(_on_body_shape_entered)

func _on_body_shape_entered(_rid, body, _body_shape, area_shape_index):
	if not body is Hero and not body.state_machine.current_state.death_prone:
		return
	var local_shape_node = get_collision_shape_by_index(area_shape_index)
	var direction: int = local_shape_node.direction
	if body.current_checkpoint_path == local_shape_node.get_path() and not local_shape_node.always_trigger:
		return
	if not direction:
		direction = body.facing_direction
		
	body.update_current_checkpoint_info(local_shape_node.get_path(), direction)
	Events.hero_reached_checkpoint.emit()
	await get_tree().process_frame
	SaveManager.save_file()

func get_collision_shape_by_index(shape_index: int) -> CollisionShape2D:
	var shapes = get_children().filter(func(node): return node is CollisionShape2D)
	if shape_index >= 0 and shape_index < shapes.size():
		return shapes[shape_index]
	return null
