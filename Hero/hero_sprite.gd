extends Sprite2D

var original_material: Material = null
@onready var hero: = get_parent()

func _ready():
	original_material = material


func _process(_delta):
	set_flip_h(get_parent().facing_direction == -1)
	rotation_degrees = hero.current_blunder_jump_angle

