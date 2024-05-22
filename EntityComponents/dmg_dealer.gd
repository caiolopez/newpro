class_name DmgDealer extends Area2D

@export var DMG_AMOUNT: int = 1
var dmg_taker: DmgTaker
var is_foe: bool = true

func _ready():
	if "is_foe" in get_parent():
		is_foe = get_parent().is_foe
	else:
		push_warning("DmgDealer component parent has no is_foe flag. Defaults to true.")
	dmg_taker = Utils.find_dmg_taker(self.get_parent())


func _process(_delta):
	if dmg_taker != null:
		if dmg_taker.current_hp == 0:
			monitorable = false
			monitoring = false
		else:
			monitorable = true
			monitoring = true
