class_name DmgDealer extends Area2D

@export var DMG_AMOUNT: int = 1
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
var is_foe: bool = true


func _ready():
	if "is_foe" in get_parent():
		is_foe = get_parent().is_foe


func _process(_delta):
	if dmg_taker != null:
		if dmg_taker.current_hp == 0:
			monitorable = false
			monitoring = false
		else:
			monitorable = true
			monitoring = true
