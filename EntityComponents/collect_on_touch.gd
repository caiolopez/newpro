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

var picked_up: bool = false

func _ready() -> void:
	Events.hero_respawned_at_checkpoint.connect(_reset_status)
	Events.hero_reached_checkpoint.connect(_commit_status)

	body_entered.connect(func(body):
		if not body is Hero: return
		if not body.state_machine.current_state.death_prone: return
		set_deferred("monitoring", false)
		picked_up = true

		if parent.has_method("pickup"):
			parent.pickup()
		else:
			parent.hide()

		Events.hero_got_collectible.emit(COLLECTIBLE_TYPE.keys()[type])
		)

func _commit_status() -> void:
	if picked_up:
		SaveManager.log_entity_change(parent, "dead")
		parent.queue_free()


func _reset_status() -> void:
	picked_up = false
	set_deferred("monitoring", true)
