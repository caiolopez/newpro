class_name FaceHero extends Node2D

@export var face_hero: bool = false
@onready var parent: Node2D = get_parent()
@onready var hero: CharacterBody2D = Utils.find_hero()
var last_hero_dir: int
signal update(dir: int)


func _process(_delta):
	if hero and face_hero:
		var hero_dir = sign(hero.global_position.x - parent.global_position.x)
		if hero_dir != last_hero_dir:
			last_hero_dir = hero_dir
			update.emit(hero_dir)

