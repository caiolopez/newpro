@tool
class_name UniqueCollider extends CollisionShape2D


func _ready():
	if Engine.is_editor_hint() and shape:
		shape = shape.duplicate()
		print("Generated unique shape for ", self.name)
