class_name Shooter extends Node2D

@export var pellet_amount: int = 1 ## The amount of projectiles released in a shot.
@export var pellet_separation_angle: float = 30 ## The amount of projectiles released in a shot.
@export var pellet_speed: float = 500
@export var bullet_type: Constants.BulletType
@export var shoots_underwater_ammo: bool = false
@export var rotates_with_parent: bool = false
@export var time_before_visible: float = 0.01 ## The time it takes for the bullet to become visible after being shot. Useful to hide bullets before they left the barrel, for instance.
@export var muzzle: Node2D = null ## The reference for the muzzle graphics from who shot it.
@export var sound_fx: StringName = &"" ## The name of the audio sfx, as in the AudioManager sfx dictionary. Leave empty to no sound.
@export var sound_fx_volume_adjustment: float = 0.0
@export var emit_signal_upon_shooting: bool = true
@export_group("autoshoot")
@export var auto_shoots: bool = true
@export var time_between_shots: float = 1
@export var shot_burst_amount: int = 3
@export_range(0.001, 5) var time_between_bursts: float = 1
@export_group("")
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var timer_shot_cooldown: Timer = get_node("TimeBetweenShots")
@onready var timer_burst_cooldown: Timer = get_node("TimeBetweenBursts")
@onready var is_foe: bool = Utils.check_if_foe(self.get_parent()) ## If no FriendOrFoe sibling component is found, assumes is_foe = true.
@onready var og_pos: Vector2 = position
var face_hero_node: FaceHero
var is_in_water: bool = false
var shot_offset: Vector2 = Vector2.ZERO
var facing_direction: int = 1
var current_burst_count: int = 1
var halt: bool = false
signal just_shot

func _ready():
	if get_parent().has_node("FaceHero"):
		face_hero_node = get_parent().get_node("FaceHero")
		face_hero_node.update.connect(update_direction)
	
	timer_shot_cooldown.wait_time = time_between_shots
	timer_burst_cooldown.wait_time = time_between_bursts
	
	timer_shot_cooldown.timeout.connect(automate_shooting)
	Events.hero_respawned_at_checkpoint.connect(reset_behavior)
	
	Events.hero_died.connect(func(): halt = true)
	Events.hero_respawned_at_checkpoint.connect(func(): halt = false)

	if auto_shoots:
		timer_shot_cooldown.start()

func automate_shooting():
	if halt: return
	if dmg_taker != null:
		if dmg_taker.current_hp == 0:
			timer_shot_cooldown.stop()
			return
	if not timer_burst_cooldown.is_stopped():
		return
	if current_burst_count == shot_burst_amount:
		current_burst_count = 0
		if time_between_bursts > 0:
			timer_burst_cooldown.start()
	current_burst_count += 1
	shoot()

func shoot(speed: float = pellet_speed, angle: float = 0, amount: int = pellet_amount, ignore_facing_direction: bool = false, inverted: bool = false) -> Array[Area2D]:
	var cur_rotation: float = 0

	if not ignore_facing_direction:
		if "facing_direction" in get_parent():
			facing_direction = get_parent().facing_direction
		else:
			if get_parent().scale.x < 0:
				facing_direction = -1
	else:
		facing_direction = 1
	
	if inverted:
		facing_direction *= -1

	if rotates_with_parent:
		cur_rotation = get_parent().rotation_degrees

	var top_angle: float = (amount-1) * pellet_separation_angle / 2
	var bullets: Array[Area2D] = []

	var b_type = bullet_type
	if shoots_underwater_ammo and is_in_water:
		b_type = Constants.BulletType.UNDERWATER

	for i in range(amount):
		var bullet: Area2D = BulletManager.place_bullet(
			facing_direction,
			get_parent().global_position + Vector2(position.x * facing_direction, position.y).rotated(deg_to_rad(cur_rotation)),
			Vector2(speed, 0),
			is_foe,
			b_type,
			(top_angle - pellet_separation_angle * i) + cur_rotation + angle,
			time_before_visible,
			shoots_underwater_ammo,
			muzzle
		)
		bullets.append(bullet)
	if emit_signal_upon_shooting:
		just_shot.emit()
		Events.entity_shot.emit(self)
	if sound_fx:
		AudioManager.play_sfx(sound_fx, sound_fx_volume_adjustment)
	if emit_signal_upon_shooting: just_shot.emit()
	return bullets

func shoot_ad_hoc(speed: float = 200, angle: float = 0, ignore_facing_direction: bool = false, inverted: bool = false) -> Array[Area2D]:
	return shoot(speed, angle, 1, ignore_facing_direction, inverted)

func update_direction(dir: int):
	if dir != 0:
		facing_direction = dir
	else:
		push_error("Direction should never be zero.")

func reset_behavior():
	if auto_shoots:
		current_burst_count = 1
		timer_shot_cooldown.start()
		timer_burst_cooldown.stop()

func return_to_og_pos():
	position = og_pos
