class_name DmgDealer extends Area2D

@export var DMG_AMOUNT: int = 1
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var is_foe: bool = Utils.check_if_foe(self.get_parent()) ## If no FriendOrFoe sibling component is found, assumes is_foe = true.


func _ready():
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.resurrected.connect(on_resurrected)


func on_died():
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)


func on_resurrected():
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("enabled", true)
