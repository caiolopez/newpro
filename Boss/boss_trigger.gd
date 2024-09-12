extends Area2D

@export var boss: Node
@export var doors_to_close: Array[Door] = []
var is_active: bool = false

func _ready():
	body_entered.connect(func(body):
		if not body is Hero\
		or is_active:
			return
		if boss and boss != null:
			Events.boss_trigger_entered.emit(boss)
			close_doors()
			is_active = true
		)
	Events.hero_respawned_at_checkpoint.connect(func():
		is_active = false
		)

func close_doors():
	for d in doors_to_close:
		d.close()
