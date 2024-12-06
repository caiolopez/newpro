class_name GfxController extends Node2D

@export var hide_when_dead: bool = true
@export var force_children_to_use_parent_material: bool = true
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
var face_hero_node: FaceHero
var shooter_node: Shooter
var original_material: Material = null

func _ready() -> void:
	original_material = material

	if get_parent().has_node("FaceHero"):
		face_hero_node = get_parent().get_node("FaceHero")
		face_hero_node.update.connect(_update_direction)

	if get_parent().has_node("Shooter"):
		shooter_node = get_parent().get_node("Shooter")
		shooter_node.just_shot.connect(_on_shoot)

	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.restored.connect(on_restored)
		dmg_taker.suffered.connect(on_suffered)
		dmg_taker.regenerated.connect(on_regenerated)

	if force_children_to_use_parent_material:
		for child in get_children():
			if child is Node2D:
				child.use_parent_material = true

func _update_direction(dir: int, rot: float = 0):
	if dir != 0:
		scale.x = abs(scale.x) * dir
	else:
		push_error("Direction should never be zero.")
	rotation = rot

func set_movement_halted(halted: bool = false):
	for c in get_children():
		if c is AnimatedSprite2D:
			if halted == true:
				c.animation = &"idle"
			else:
				c.animation = &"moving"

func _on_shoot():
	for c in get_children():
		if c is AnimatedSprite2D:
			c.play(&"shoot")

func on_died():
	if hide_when_dead:
		visible = false

func on_restored():
	visible = true
	reset_physics_interpolation()
	get_parent().reset_physics_interpolation()

func on_suffered(_hp):
	Utils.colorize_silhouette(true, self, 0.1)

func on_regenerated():
	Utils.colorize_silhouette(true, self, 0.02, Color.RED)
