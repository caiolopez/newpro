@tool
class_name UniqueCollider extends CollisionShape2D

func _enter_tree():
	if Engine.is_editor_hint():
		call_deferred("ensure_unique_shape")

func ensure_unique_shape():
	if shape:
		var current_hash = hash_shape(shape)
		if not has_meta("original_shape_hash"):
			set_meta("original_shape_hash", current_hash)
		
		if get_meta("original_shape_hash") == current_hash:
			shape = shape.duplicate()
			set_meta("original_shape_hash", hash_shape(shape))
			if DebugTools.print_stuff: print("Generated unique shape for ", self.name)

func hash_shape(s: Shape2D) -> int:
	return hash(s.get_instance_id()) & 0x7FFFFFFF
