class_name KillFoeBulletsIfDead extends Node

@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())

func _ready() -> void:
	if dmg_taker != null:
		dmg_taker.died.connect(func():
			BulletManager.kill_all_foe_bullets()
			)
