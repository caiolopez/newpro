class_name EntityCollider extends CollisionShape2D

@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())

func _ready() -> void:
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.restored.connect(on_restored)


func on_died():
	self.set_deferred("disabled", true)


func on_restored():
	self.set_deferred("disabled", false)
