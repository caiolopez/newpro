extends Area2D

@export var recall_hero_direction: bool = false
var direction: int = 1

func _ready():
	body_entered.connect(on_body_entered)
	if scale.x < 0: direction = -1

func on_body_entered(body):
	if not body is Hero: return
	if body.current_checkpoint_path == self.get_path(): return
	if recall_hero_direction: direction = body.facing_direction
	body.update_current_checkpoint_path(self.get_path())
	Events.hero_reached_checkpoint.emit()
