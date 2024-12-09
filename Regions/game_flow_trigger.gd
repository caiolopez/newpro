class_name GameFlowTrigger extends Area2D

enum Effects {
	NONE = 0,
	TRIGGER_ENDING = 1
	}
@export var effect: Effects = Effects.NONE ## The effect that will happen to all children of this node, as well as to any node appended to the Entities Array.
@export_category("Optional")
@export var use_this_trigger_area: Area2D = null ## When not empty, will activate upon body or area entering this area as well.

func _ready() -> void:
	if use_this_trigger_area:
		use_this_trigger_area.body_entered.connect(_on_body_entered)
	else:
		body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if not body is Hero: return
	if not body.state_machine.current_state.death_prone: return

	match effect:
		Effects.TRIGGER_ENDING:
			AppManager.transition_to_game_ending()
