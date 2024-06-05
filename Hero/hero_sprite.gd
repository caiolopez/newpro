extends Sprite2D

var original_material: Material = null

func _ready():
	original_material = material


func _process(_delta):
	set_flip_h(get_parent().facing_direction == -1)

