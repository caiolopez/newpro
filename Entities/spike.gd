extends Node2D

@export var is_foe: bool = true
var dmg_taker: DmgTaker

func _ready():
	dmg_taker = Utils.find_dmg_taker(self)


func _process(_delta):
	if dmg_taker != null:
		if dmg_taker.current_hp == 0 and visible: die()
		if dmg_taker.current_hp > 0 and not visible: resurect()


func die():
	visible = false


func resurect():
	visible = true
