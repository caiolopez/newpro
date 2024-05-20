extends Node2D



func _ready():
	pass


func _process(delta):
	if get_node("DmgTaker").current_hp == 0 and visible: die()
	if get_node("DmgTaker").current_hp > 0 and not visible: resurect()


func die():
	visible = false


func resurect():
	visible = true
