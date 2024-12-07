class_name SineMovement
extends Node

@onready var parent: Node2D = get_parent()
@onready var initial_position: Vector2 = parent.position

@export var frequency: Vector2 = Vector2(0.0, 2.0)
@export var amplitude: Vector2 = Vector2(0.0, 10.0)
@export var randomize_starting_time: bool = false

var time: float = 0.0

func _ready() -> void:
	if randomize_starting_time:
		time += randf()


func _physics_process(delta: float) -> void:
	time += delta

	parent.position.y = sin(time * frequency.x) * amplitude.y + initial_position.y
	parent.position.x = sin(time * frequency.y) * amplitude.x + initial_position.x
