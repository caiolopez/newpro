extends Node2D

var original_material: Material = null
var flippable_children = {}
@onready var hero: = get_parent()

func _ready():
	material.set_shader_parameter("replace_black", Constants.HERO_DARK)
	material.set_shader_parameter("replace_white", Constants.HERO_LIGHT)
	original_material = material
	for child in get_children():
		if child.has_method("set_flip_h"):
			flippable_children[child] = child.position

func _process(_delta):
	for child in flippable_children:
		child.set_flip_h(hero.facing_direction == -1)
		child.rotation_degrees = hero.current_blunder_jump_angle
		child.position.x = flippable_children[child].x * hero.facing_direction
