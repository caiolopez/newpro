class_name Shooter extends Node2D

@export var pellet_amount: int = 1 ## The amount of projectiles released in a shot.
@export var pellet_separation_angle: float = 30 ## The amount of projectiles released in a shot.
@export var pellet_speed: float = 500
@export var shoots_fire: bool = false
@export var rotates_with_parent: bool = false
@export_group("autoshoot")
@export var auto_shoots: bool = true
@export var time_between_shots: float = 1
@export var shot_burst_amount: int = 3
@export_range(0.001, 5) var time_between_bursts: float = 1
@export_group("")
@onready var dmg_taker: DmgTaker = Utils.find_dmg_taker(self.get_parent())
@onready var timer_shot_cooldown: Timer = get_node("TimeBetweenShots")
@onready var timer_burst_cooldown: Timer = get_node("TimeBetweenBursts")
var shot_offset: Vector2 = Vector2.ZERO
var is_foe: bool = true
var facing_direction: int = 1
var current_burst_count: int = 1


func _ready():
	timer_shot_cooldown.wait_time = time_between_shots
	timer_burst_cooldown.wait_time = time_between_bursts
	
	timer_shot_cooldown.timeout.connect(automate_shooting)
	Events.respawned_at_checkpoint.connect(reset_shooting)
	
	if auto_shoots:
		timer_shot_cooldown.start()
	
	if "is_foe" in get_parent():
		is_foe = get_parent().is_foe


func automate_shooting():
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


func shoot(speed: float = pellet_speed, angle: float = 0, amount: int = pellet_amount) -> Array[Area2D]:
	var cur_rotation: float = 0
	
	if "facing_direction" in get_parent():
		facing_direction = get_parent().facing_direction
	else:
		if get_parent().scale.x < 0:
			facing_direction = -1
	
	if rotates_with_parent:
		cur_rotation = get_parent().rotation_degrees
	
	
	var top_angle: float = (amount-1) * pellet_separation_angle / 2
	var bullets: Array[Area2D] = []
	
	for i in range(amount):
		var bullet: Area2D = BulletManager.create_bullet(
			facing_direction,
			get_parent().position + Vector2(position.x * facing_direction, position.y),
			Vector2(speed, 0),
			is_foe,
			shoots_fire,
			(top_angle - pellet_separation_angle * i) + cur_rotation + angle)
		bullets.append(bullet)
	return bullets
	

func shoot_ad_hoc(speed: float = 200, angle: float = 0) -> Array[Area2D]:
	return shoot(speed, angle, 1)


func reset_shooting():
	if auto_shoots:
		current_burst_count = 1
		timer_shot_cooldown.start()
		timer_burst_cooldown.stop()
