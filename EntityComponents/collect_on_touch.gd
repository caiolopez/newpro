class_name CollectOnTouch extends Area2D

enum COLLECTIBLE_TYPE {
	NONE = 0,
	INCENDIARY_AMMO = 1,
	UNDERWATER_AMMO = 2,
	AQUALUNG = 3,
	TELEPORTER = 4,
	LORE = 5
}

@onready var parent := get_parent()
@export var type: COLLECTIBLE_TYPE = COLLECTIBLE_TYPE.NONE
@export var animation_name: StringName = &"pickup"

func _ready() -> void:
	body_entered.connect(func(body):
		if !body is Hero: return
		set_deferred("monitoring", false)
		_animate()
		Events.hero_got_collectible.emit(COLLECTIBLE_TYPE.keys()[type])
		)

func _animate():
	if parent is AnimatedSprite2D:
		parent.play(animation_name)
	else:
		SaveManager.log_entity_change(parent, "dead")
		parent.queue_free()
