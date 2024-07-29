extends Node2D

var original_material: Material = null
@onready var original_scale: Vector2 = scale
@onready var hero: = get_parent()

func _ready():
	#material.set_shader_parameter("replace_black", Constants.HERO_DARK)
	#material.set_shader_parameter("replace_white", Constants.HERO_LIGHT)
	original_material = material

func _process(_delta):
		rotation_degrees = hero.current_blunder_jump_angle
		scale.x = original_scale.x * hero.facing_direction
