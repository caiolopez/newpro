class_name DmgTaker extends Area2D

@export var HP_AMOUNT: int = 1
@export var IGNORE_ON_CHECKPOINT: bool = false
var current_hp: int
var immune: bool = false
var immune_to_regular_bullets: bool = false ## Will not take damage from non-incendiary bullets.
var is_foe: bool = true

# Subtracts HP upon collision with DmgDealers.


func _ready():
	if "is_foe" in get_parent():
		is_foe = get_parent().is_foe
	else:
		push_warning("DmgTaker component requires parent to have an is_foe flag")
	current_hp = HP_AMOUNT
	Events.reached_checkpoint.connect(commit_status)
	Events.respawned_at_checkpoint.connect(reset_status)


func take_dmg(amount: int):
	if immune: return
	if current_hp <= 0:
		return
	
	current_hp -= amount
	current_hp = maxi(current_hp, 0)
	print("Foe: ", is_foe, ". Damage taken: ", amount, ". Current HP: ", current_hp)


func _on_area_entered(area):
	if not area.is_in_group("dmg_dealers"): return
	if is_foe == area.is_foe: return
	
	if area.is_in_group("bullets"):
		if not area.is_fire and immune_to_regular_bullets:
			return
		if current_hp > 0: area.kill_bullet()

	take_dmg(area.DMG_AMOUNT)


func commit_status():
	if IGNORE_ON_CHECKPOINT: return
	if current_hp == 0 and is_foe:
		get_parent().queue_free()


func reset_status():
	if IGNORE_ON_CHECKPOINT: return
	current_hp = HP_AMOUNT

