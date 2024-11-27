extends MeshInstance3D

@onready var frequency: float = randf_range(1.0, 2.0)
@onready var amplitude: float = randf_range(0.5, 2.0)
@onready var initial_z: float = -10.0

var time: float = 0.0

func _process(delta: float) -> void:
	time += delta
	position.z = sin(time * frequency) * amplitude + initial_z
