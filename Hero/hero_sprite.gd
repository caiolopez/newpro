extends Node2D

@onready var original_scale: Vector2 = scale
@onready var hero: = get_parent()
var original_material: Material = null

func _ready():
	original_material = material

func _process(_delta):
		scale.x = original_scale.x * hero.facing_direction
