class_name EntityCollider extends CollisionShape2D

@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())

func _ready():
	if dmg_taker != null:
		dmg_taker.died.connect(on_died)
		dmg_taker.resurrected.connect(on_resurrected)


func on_died():
	self.set_deferred("disabled", true)


func on_resurrected():
	self.set_deferred("disabled", false)
