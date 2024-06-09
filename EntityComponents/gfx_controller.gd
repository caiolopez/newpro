class_name GfxController extends Node2D

@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
var facing_direction_node: Node2D


func _ready():
	if get_parent().has_node("FacingDirection"):
		facing_direction_node = get_parent().get_node("FacingDirection")
		facing_direction_node.update.connect(on_update_direction)
	
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.resurrected.connect(on_resurrected)
		dmg_taker.suffered.connect(on_suffered)


func on_update_direction(dir: float):
	scale.x = dir


func on_died():
	visible = false


func on_resurrected():
	visible = true


func on_suffered():
	Utils.paint_white(true, get_node("Sprite2D"), 0.1)
