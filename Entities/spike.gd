extends Node2D

@export var is_foe: bool = true
@onready var sprite: Sprite2D = $Sprite2D
var dmg_taker: DmgTaker

func _ready():
	dmg_taker = Utils.find_dmg_taker(self)


func _process(_delta):
	if dmg_taker != null:
		if dmg_taker.current_hp == 0 and sprite.visible:
			die()
		if dmg_taker.current_hp > 0 and not sprite.visible:
			resurrect()


func die():
	sprite.visible = false
	print(name, " DIED")


func resurrect():
	sprite.visible = true
	print(name, " RESURRECTED")
