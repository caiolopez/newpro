class_name FacingDirection extends Node2D

@export var face_hero: bool = false ## If set to true, the entity will always flip horizontally to face the hero. If set to false, it will obbey movement components.
@onready var parent: CharacterBody2D = get_parent()
@onready var hero: CharacterBody2D
var last_hero_dir: int
signal update(dir: int)


func _ready():
	if not get_tree().get_nodes_in_group("heroes").is_empty():
		hero = get_tree().get_nodes_in_group("heroes")[0]


func _process(_delta):
	if face_hero and hero:
		var hero_dir = sign(hero.global_position.x - parent.global_position.x)
		if hero_dir != last_hero_dir:
			last_hero_dir = hero_dir
			update.emit(hero_dir)

