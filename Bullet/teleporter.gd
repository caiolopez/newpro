class_name Teleporter extends Area2D

var is_available: bool = true


func _ready():
	area_entered.connect(func(area: Area2D):
		if area is Bullet\
		and area.visible\
		and not area.is_foe:
			var destination = global_position + Vector2(signf(scale.x)*64, 0)
			Events.hero_hit_teleporter.emit(destination)
			Utils.paint_white(true, get_node("Sprite2D"), 0.1)
			area.kill_bullet()
	)

