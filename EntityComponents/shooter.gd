class_name Shooter extends Node

@export var pellet_amount: int = 3
@export var pellet_separation_angle: int = 30
@export var pellet_speed: float = 300
@export var shot_burst: int = 3
@export var shot_origin:= Vector2.ZERO
@export var shoots_fire:= false
var is_foe: bool = true
var dmg_taker: DmgTaker
var facing_direction:= 1
var time_between_shots: Timer
var time_between_bursts: Timer


func _ready():
	if "is_foe" in get_parent():
		is_foe = get_parent().is_foe

	if "facing_direction" in get_parent():
		facing_direction = get_parent().facing_direction
	else:
		if get_parent().scale.x < 0:
			facing_direction = -1

	dmg_taker = Utils.find_dmg_taker(self.get_parent())

	time_between_shots = get_node("TimeBetweenShots")
	time_between_bursts = get_node("TimeBetweenBursts")

func _process(_delta):
	if time_between_shots.is_stopped():
		shoot_scatter()
		time_between_shots.start()
		
		
	

func shoot_scatter():
	var top_angle = (pellet_amount-1) * pellet_separation_angle / 2
	for i in range(pellet_amount):
		BulletManager.create_bullet(facing_direction, get_parent().position + shot_origin, Vector2(pellet_speed, 0), is_foe, shoots_fire, top_angle - pellet_separation_angle * i)
