extends RayCast2D

var hero: CharacterBody2D
var og_target_pos: Vector2

func _ready():
	og_target_pos = target_position
	hero = get_node("../../Hero")

func update_direction():
	target_position.x = hero.facing_direction * og_target_pos.x
