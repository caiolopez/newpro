@tool
class_name UniqueCollider extends CollisionShape2D

@export var is_unique: bool = false ## Read only. This variable is only exported so it can be serialized. Do not change it.

func _ready():
	if Engine.is_editor_hint() and shape and not is_unique:
		shape = shape.duplicate()
		is_unique = true
		print("Generated unique shape for ", self.name)
