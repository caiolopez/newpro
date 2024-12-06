extends Area2D

@export var background: StringName = ""

func _ready() -> void:
	body_entered.connect(func(body):
		if not body is Hero: return
		if not body.state_machine.current_state.death_prone: return
		BackgroundManager.change_background(background)
		)
