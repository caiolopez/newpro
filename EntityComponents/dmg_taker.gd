extends Area2D

@export var HP_AMOUNT: int = 1
@export var IS_FOE: bool = true
var current_hp: int
var immune: bool = false
var immune_to_regular_bullets: bool = false ## Will not take damage from non-incendiary bullets.



func _ready():
	current_hp = HP_AMOUNT
	Events.reached_checkpoint.connect(commit_status)
	Events.respawned_at_checkpoint.connect(reset_status)


func take_dmg(amount: int):
	if immune: return
	if current_hp <= 0:
		push_error("Can't take damage: HP is already 0.")
		return
	
	current_hp -= amount
	current_hp = maxi(current_hp, 0)
	print("Damage taken: ", amount, ". Current HP: ", current_hp)


func _on_area_entered(area):
	if not area.is_in_group("dmg_dealers"): return
	if IS_FOE == area.is_foe: return
	
	if area.is_in_group("bullets"):
		if not area.is_fire and immune_to_regular_bullets:
			return

		take_dmg(area.DMG_AMOUNT)
		area.kill_bullet()
		return
		
	take_dmg(area.DMG_AMOUNT)


func commit_status():
	if current_hp == 0: get_parent().queue_free()


func reset_status():
	current_hp = HP_AMOUNT

