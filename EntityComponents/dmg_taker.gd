class_name DmgTaker extends Area2D

@export var HP_AMOUNT: int = 1
@export var RESET_UPON_RESPAWN: bool = true ## When set to true, entities will have all their attributes reset when the Hero respawns.
@export var QUEUE_FREE_ON_CHECKPOINT: bool = true ## When set to true, will prevent dead entities from reappearing when the Hero respawns.
@export var immune_to: Array[Constants.BulletType] = [] ## Bullet types in this list will not affect entities.
@export var auto_regen_time: float = 0.0 ## The time it takes for it to regain one HP automatically. Set to zero to disable feature.
@onready var is_foe: bool = Utils.check_if_foe(self.get_parent()) ## If no FriendOrFoe sibling component is found, assumes is_foe = true.
@onready var current_hp: int = HP_AMOUNT
var currently_immune: bool = false
var last_processed_bullet: Bullet = null
var regen_timer: Timer = null

signal died
signal resurrected
signal suffered(hp: int)
signal regenerated


func _ready():
	Events.hero_reached_checkpoint.connect(commit_status)
	Events.hero_respawned_at_checkpoint.connect(reset_status)
	body_entered.connect(func(_body): take_dmg(1))
	area_entered.connect(on_area_entered)
	area_exited.connect(func(area): if area == last_processed_bullet:
		last_processed_bullet = null, CONNECT_DEFERRED)

	if auto_regen_time > 0:
		regen_timer = Timer.new()
		regen_timer.wait_time = auto_regen_time
		regen_timer.timeout.connect(regen_dmg)
		add_child(regen_timer)
		if current_hp < HP_AMOUNT:
			regen_timer.start()


func regen_dmg():
	if current_hp < HP_AMOUNT:
		current_hp = mini(current_hp + 1, HP_AMOUNT)
		regenerated.emit()
		if DebugTools.print_stuff: print(get_parent().name, ": HP restored: 1. Current HP: ", current_hp)


func take_dmg(amount: int):
	if currently_immune\
	or current_hp <= 0:
		return

	current_hp = maxi(current_hp - amount, 0)
	if current_hp == 0:
		if regen_timer:
			regen_timer.stop()
		died.emit()
	else:
		suffered.emit(current_hp)
		if regen_timer:
			regen_timer.stop()
			regen_timer.start()
	if DebugTools.print_stuff: print(get_parent().name, ": Damage taken: ", amount, ". Current HP: ", current_hp)


func on_area_entered(area):
	if current_hp <= 0: return
	if not area.is_in_group("dmg_dealers"): return
	if area.is_foe == self.is_foe: return

	if area is Bullet:
		if area == last_processed_bullet: return
		last_processed_bullet = area
		area.kill_bullet()
		if area.bullet_type in immune_to: return

	take_dmg(area.DMG_AMOUNT)


func commit_status():
	if not QUEUE_FREE_ON_CHECKPOINT: return
	if current_hp == 0 and is_foe:
		SaveManager.log_entity_change(get_parent(), "dead")
		get_parent().queue_free()


func reset_status():
	if not RESET_UPON_RESPAWN: return
	current_hp = HP_AMOUNT
	if regen_timer:
		regen_timer.start()
	resurrected.emit()
