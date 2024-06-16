extends Area2D

@export var boss: Node

func _ready():
	body_entered.connect(func(body):
		if not body is Hero:
			return
		if boss and boss != null:
			Events.boss_trigger_entered.emit(boss)
		)
