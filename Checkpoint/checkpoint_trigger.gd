extends Area2D

enum Direction {
	LEFT = -1, ## Hero will respawn facing left.
	RIGHT = 1, ## Hero will respawn facing right.
	RECALL_HERO_DIRECTION = 0 ## Hero will respawn facing the direction he was when the trigger was entered.
	}
@export var direction: Direction = Direction.RECALL_HERO_DIRECTION
@export var force_trigger: bool = false ## If set to true, causes this checkpoint to work even if it is already the current one. NOTE: Developed so designers don't have to place two normal checkpoints back to back after boss battles.
var recall: bool = false

func _ready():
	if not direction:
		recall = true
		direction = Direction.RIGHT
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if not body is Hero: return
	if not body.state_machine.current_state.death_prone: return
	if body.current_checkpoint_path == self.get_path() and not force_trigger:
		return
	if recall:
		direction = body.facing_direction
	body.update_current_checkpoint_path(self.get_path())
	Events.hero_reached_checkpoint.emit()
	await get_tree().process_frame
	SaveManager.save_file()
