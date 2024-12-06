class_name DmgDealer extends Area2D

@export var DMG_AMOUNT: int = 1
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var is_foe: bool = Utils.check_if_foe(self.get_parent())


func _ready() -> void:
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.restored.connect(on_restored)


func on_died():
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)


func on_restored():
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", false)
