class_name DmgDealer extends Area2D

@export var DMG_AMOUNT: int = 1
@export var is_foe: bool = true
var taker: Area2D

func _ready():
	for child in get_parent().get_children():
		if child is DmgTaker:
			taker = child


func _process(delta):
	if taker != null:
		if taker.current_hp == 0:
			monitorable = false
			monitoring = false
		else:
			monitorable = true
			monitoring = true
