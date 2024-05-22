class_name DmgDealer extends Area2D

@export var DMG_AMOUNT: int = 1
var dmg_taker: DmgTaker
var is_foe: bool = true

func _ready():
	if "is_foe" in get_parent():
		is_foe = get_parent().is_foe
	else:
		push_warning("DmgDealer component requires parent to have an is_foe flag")
	dmg_taker = Utils.find_dmg_taker(self.get_parent())


func _process(delta):
	if dmg_taker != null:
		if dmg_taker.current_hp == 0:
			monitorable = false
			monitoring = false
		else:
			monitorable = true
			monitoring = true
