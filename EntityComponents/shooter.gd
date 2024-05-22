class_name Shooter extends Node

@export var pellet_amount: int = 1
@export var pellet_separation_angle: int = 1
@export var pellet_speed: int = 1
@export var shot_burst: int = 1
@export var is_foe: bool = true
var dmg_taker: DmgTaker


func _ready():
	dmg_taker = Utils.find_dmg_taker(self.get_parent())


func _process(delta):
	if dmg_taker != null:
		if dmg_taker.current_hp == 0:
			pass
		else:
			pass
