class_name FaceHero extends Node

@export var face_hero: bool = false
@onready var parent: Node2D = get_parent()
var hero: Hero = null
var last_hero_dir: int = 1
signal update(dir: int)

func _ready() -> void:
	AppManager.hero_ready.connect(func():
		hero = AppManager.hero
		)

func _process(_delta):
	if hero and face_hero:
		var hero_dir = sign(hero.global_position.x - parent.global_position.x)
		if hero_dir != last_hero_dir:
			last_hero_dir = hero_dir
			update.emit(hero_dir)
