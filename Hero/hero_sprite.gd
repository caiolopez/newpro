extends AnimatedSprite2D

var original_material: Material = null
@onready var hero: = $"../.."

func _ready():
	original_material = material


func _process(_delta):
	set_flip_h(hero.facing_direction == -1)
	rotation_degrees = hero.current_blunder_jump_angle
