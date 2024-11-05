extends Node

## Rotates MeshInstance3D objects

@export var rotation_speed = Vector3(0.5, 0.5, 0.5)
@export var randomize_rotations: bool = false
@onready var parent: MeshInstance3D = get_parent()

func _ready() -> void:
	if randomize_rotations:
		parent.rotate_x(randf())
		parent.rotate_y(randf())
		parent.rotate_z(randf())

func _physics_process(delta):
	parent.rotate_x(rotation_speed.x * delta)
	parent.rotate_y(rotation_speed.y * delta)
	parent.rotate_z(rotation_speed.z * delta)
