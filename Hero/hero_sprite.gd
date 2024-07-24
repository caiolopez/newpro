extends Node2D

var original_material: Material = null
@onready var hero: = get_parent()

func _ready():
	original_material = material

func _process(_delta):
	for child in get_children():
		if child.has_method("set_flip_h"):
			child.set_flip_h(hero.facing_direction == -1)
		child.rotation_degrees = hero.current_blunder_jump_angle
		child.position.x = abs(child.position.x) * -hero.facing_direction
