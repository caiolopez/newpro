extends Node2D



func _ready():
	pass


func _process(delta):
	if get_node("DmgTaker").current_hp == 0 and get_node("Sprite2D").visible: die()
	if get_node("DmgTaker").current_hp > 0 and not get_node("Sprite2D").visible: resurect()


func die():
	get_node("Sprite2D").visible = false


func resurect():
	get_node("Sprite2D").visible = true
