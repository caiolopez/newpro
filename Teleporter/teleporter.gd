class_name Teleporter extends Area2D

var is_active: bool = false

func _ready():
	Events.teleporters_activated.connect(_animate_activation)
	
	if AppManager.teleporters_are_active:
		is_active = true
	
	area_entered.connect(func(area: Area2D):
		if area is Bullet\
		and not area.is_foe\
		and is_active:
			var destination = global_position + Vector2(signf(scale.x)*64, 0)
			Events.hero_hit_teleporter.emit(destination)
			Utils.colorize_silhouette(true, get_node("AnimatedSprite2D"), 0.1)
			area.kill_bullet()
	)

func _animate_activation(active):
	is_active = active
	if is_active:
		$AnimatedSprite2D.play("activating")
	else:
		$AnimatedSprite2D.play("offline")
	
