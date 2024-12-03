class_name SineMovement
extends Node

@onready var parent: Node2D = get_parent()
@export var frequency: float = 2.0
@export var amplitude: float = 10.0

var time: float = 0.0
var initial_position: Vector3 = Vector3.ZERO

func _physics_process(delta: float) -> void:
	time += delta
	parent.position.y = sin(time * frequency) * amplitude + initial_position.y
