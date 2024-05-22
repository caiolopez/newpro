extends Sprite2D

var original_material: Material = null
var white_material: ShaderMaterial = preload("res://CaioShaders/white.tres")

func _ready():
	original_material = material


func _process(_delta):
	set_flip_h(get_parent().facing_direction == -1)


func paint_white(active: bool):
	if active: material = white_material
	else: material = original_material
	

