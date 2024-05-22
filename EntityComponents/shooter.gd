class_name Shooter extends Node

@export var pellet_amount: int = 1 ## The amount of projectiles released in a shot.
@export var pellet_separation_angle: int = 30 ## The amount of projectiles released in a shot.
@export var pellet_speed: float = 500
@export var shot_origin:= Vector2.ZERO
@export var shoots_fire:= false
@export var rotates_with_parent:= false
@export var auto_shoots := true
@export var time_between_shots: float = 1
@export var shot_burst_amount: int = 3
@export var time_between_bursts: float = 0
var rotation: float = 0
var is_foe: bool = true
var dmg_taker: DmgTaker
var facing_direction:= 1
var timer_shot_cooldown: Timer
var timer_burst_cooldown: Timer
var current_burst_count: int = 1


func _ready():
	timer_shot_cooldown = get_node("TimeBetweenShots")
	timer_burst_cooldown = get_node("TimeBetweenBursts")
	
	timer_shot_cooldown.wait_time = time_between_shots
	timer_burst_cooldown.wait_time = time_between_bursts
	
	timer_shot_cooldown.timeout.connect(automate_shooting)
	Events.respawned_at_checkpoint.connect(reset_shooting)
	
	if auto_shoots: timer_shot_cooldown.start()
	
	if "is_foe" in get_parent():
		is_foe = get_parent().is_foe

	if "facing_direction" in get_parent():
		facing_direction = get_parent().facing_direction
	else:
		if get_parent().scale.x < 0:
			facing_direction = -1

	dmg_taker = Utils.find_dmg_taker(self.get_parent())

func _process(_delta):
	if rotates_with_parent: rotation = get_parent().rotation_degrees

func automate_shooting():
	if dmg_taker.current_hp == 0:
		timer_shot_cooldown.stop()
		return
	if not timer_burst_cooldown.is_stopped(): return
	if current_burst_count == shot_burst_amount:
		current_burst_count = 0
		if time_between_bursts > 0:
			timer_burst_cooldown.start()
	current_burst_count += 1
	shoot()


func shoot():
	var top_angle = (pellet_amount-1) * pellet_separation_angle / 2
	for i in range(pellet_amount):
		BulletManager.create_bullet(facing_direction, get_parent().position + shot_origin, Vector2(pellet_speed, 0), is_foe, shoots_fire, (top_angle - pellet_separation_angle * i) + rotation)


func reset_shooting():
	current_burst_count = 1
	timer_shot_cooldown.start()
	timer_burst_cooldown.stop()
