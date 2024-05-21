class_name DmgDealer extends Area2D

@export var DMG_AMOUNT: int = 1
@export var is_foe: bool = true
var dmg_taker: DmgTaker


func _ready():
	dmg_taker = Utils.find_dmg_taker(self.get_parent())


func _process(delta):
	if dmg_taker != null:
		if dmg_taker.current_hp == 0:
			monitorable = false
			monitoring = false
		else:
			monitorable = true
			monitoring = true
