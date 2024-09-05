extends Area2D

@export var hint_id: StringName
@export var one_shot: bool = false

func _ready() -> void:
	body_entered.connect(func(body):
		if not body is Hero: return
		Events.show_hint.emit(hint_id)
		)

	body_exited.connect(func(body):
		if not body is Hero: return
		Events.hide_hint.emit()
		if one_shot:
			SaveManager.log_entity_change(self, "dead")
			self.queue_free()
		)
