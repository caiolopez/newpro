extends Area2D

@export var recall_hero_direction: bool = false
var is_current_checkpoint: bool = false
var direction: int = 1



func _ready():
	if scale.x < 0: direction = -1


func _process(delta):
	pass
