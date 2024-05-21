extends Node2D

var dmg_taker: DmgTaker

func _ready():
	dmg_taker = Utils.find_dmg_taker(self)


func _process(delta):
	if dmg_taker != null:
		if dmg_taker.current_hp == 0 and visible: die()
		if dmg_taker.current_hp > 0 and not visible: resurect()


func die():
	visible = false


func resurect():
	visible = true
