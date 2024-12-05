extends Label

var current_notification_tween: Tween = null

func show_notification(notification_text: StringName, duration: float = 1.0) -> void:
	if current_notification_tween and current_notification_tween.is_valid():
		current_notification_tween.kill()
	self.text = notification_text
	self.modulate.a = 0
	self.visible = true
	current_notification_tween = create_tween()
	current_notification_tween.tween_property(self, "modulate:a", 1.0, 0.25)
	current_notification_tween.tween_interval(duration)
	current_notification_tween.tween_property(self, "modulate:a", 0.0, 0.25)
	await current_notification_tween.finished
	if current_notification_tween.is_valid():
		self.visible = false
		current_notification_tween = null
