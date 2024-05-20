extends Area2D

@export var recall_hero_direction: bool = false
var direction: int = 1

func _ready():
	body_entered.connect(_on_hero_entered)
	if scale.x < 0: direction = -1

func _on_hero_entered(body):
	if not body.is_in_group("heroes"): return
	if body.current_checkpoint == self: return
	if recall_hero_direction: direction = body.facing_direction
	body.update_current_checkpoint(self)
	Events.reached_checkpoint.emit()
