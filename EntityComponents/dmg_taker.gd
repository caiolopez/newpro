class_name DmgTaker extends Area2D

@export var HP_AMOUNT: int = 1
@export var RESET_UPON_RESPAWN: bool = true ## When set to true, entities will have all their attributes reset when the Hero respawns.
@export var QUEUE_FREE_ON_CHECKPOINT: bool = true ## When set to true, will prevent dead entities from reappearing when the Hero respawns.
@onready var is_foe: bool = Utils.check_if_foe(self.get_parent()) ## If no FriendOrFoe sibling component is found, assumes is_foe = true.
@onready var current_hp: int = HP_AMOUNT
var immune: bool = false
var immune_to_regular_bullets: bool = false ## Will not take damage from non-incendiary bullets.

signal died
signal resurrected
signal suffered

func _ready():
	Events.reached_checkpoint.connect(commit_status)
	Events.respawned_at_checkpoint.connect(reset_status)


func take_dmg(amount: int):
	if immune\
	or current_hp <= 0:
		return

	current_hp -= amount
	current_hp = maxi(current_hp, 0)
	if current_hp == 0:
		died.emit()
	else:
		suffered.emit()
	print("Foe: ", is_foe, ". Damage taken: ", amount, ". Current HP: ", current_hp)


func _on_area_entered(area):
	if current_hp <= 0: return
	if not area.is_in_group("dmg_dealers"): return
	if is_foe == area.is_foe: return
	
	if area.is_in_group("bullets") and area.visible:
		if not area.is_fire and immune_to_regular_bullets:
			return
		if current_hp > 0:
			area.kill_bullet()

		take_dmg(area.DMG_AMOUNT)


func commit_status():
	if not QUEUE_FREE_ON_CHECKPOINT: return
	if current_hp == 0 and is_foe:
		get_parent().queue_free()


func reset_status():
	if not RESET_UPON_RESPAWN: return
	current_hp = HP_AMOUNT
	resurrected.emit()

