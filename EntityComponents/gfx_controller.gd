class_name GfxController extends Node2D

@export var hide_when_dead: bool = true
@export var force_children_to_use_parent_material: bool = true
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
var face_hero_node: FaceHero
var original_material: Material = null

func _ready():
	original_material = material

	if get_parent().has_node("FaceHero"):
		face_hero_node = get_parent().get_node("FaceHero")
		face_hero_node.update.connect(update_direction)

	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.resurrected.connect(on_resurrected)
		dmg_taker.suffered.connect(on_suffered)

	if force_children_to_use_parent_material:
		for child in get_children():
			child.use_parent_material = true

func update_direction(dir: float, rot: float = 0):
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

func on_died():
	if hide_when_dead:
		visible = false

func on_resurrected():
	visible = true

func on_suffered(_hp):
	Utils.paint_white(true, self, 0.1)
