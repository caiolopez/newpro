extends Area2D

@export var dialog_id: StringName
@export var one_shot: bool = false

func _ready() -> void:
	body_entered.connect(func(body):
		if not body is Hero: return
		Events.show_dialog.emit(dialog_id)
		)

	body_exited.connect(func(body):
		if not body is Hero: return
		Events.hide_dialog.emit()
		if one_shot:
			SaveManager.log_entity_change(self, "dead")
			self.queue_free()
		)
