extends Sprite2D


func _ready():
	pass


func _process(delta):
	set_flip_h(get_parent().facing_direction == -1)
