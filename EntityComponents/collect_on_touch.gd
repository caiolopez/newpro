class_name CollectOnTouch extends Area2D

enum COLLECTIBLE_TYPE {
	NONE = 0,
	INCENDIARY_AMMO = 1,
	UNDERWATER_AMMO = 2,
	AQUALUNG = 3,
	TELEPORTER = 4
}

@onready var parent: Node2D = get_parent()
@export var type: COLLECTIBLE_TYPE = COLLECTIBLE_TYPE.NONE

func _ready() -> void:
	body_entered.connect(func(body):
		if not body is Hero: return
		_animate()
		Events.hero_got_collectible.emit(COLLECTIBLE_TYPE.keys()[type])
		SaveManager.log_entity_change(parent, "dead")
		parent.queue_free()
		)

func _animate():
	pass
