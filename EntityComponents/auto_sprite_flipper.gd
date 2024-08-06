extends Node2D

@export var randomize_h: bool = true
@export var randomize_v: bool = false
@export var randomize_90deg_turn: bool = false
@onready var parent: Node2D = get_parent()

func _ready() -> void:
	randomize_flip()
	parent.animation_finished.connect(randomize_flip)

func randomize_flip():
	if randomize_h:
		parent.flip_h = bool(randi() % 2)
	if randomize_v:
		parent.flip_v = bool(randi() % 2)
	if randomize_90deg_turn:
		parent.rotation_degrees = (randi() % 2) * 90
