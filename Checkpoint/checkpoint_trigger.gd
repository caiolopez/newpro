extends Area2D

@export var recall_hero_direction: bool = false ## If set to false, respawns the hero facing forward (use negative x-values to flip trigger and hero spawn direction). If set to true, will respawn the hero facing the direction he was when the trigger was entered.
@export var force_trigger: bool = false ## If set to true, causes this checkpoint to work even if it is already the current one. NOTE: Developed so designers don't have to place two normal checkpoints back to back after boss battles.
var direction: int = 1

func _ready():
	body_entered.connect(on_body_entered)
	if scale.x < 0: direction = -1

func on_body_entered(body):
	if not body is Hero: return
	if body.current_checkpoint_path == self.get_path() and not force_trigger: return
	if recall_hero_direction: direction = body.facing_direction
	body.update_current_checkpoint_path(self.get_path())
	Events.hero_reached_checkpoint.emit()
 
