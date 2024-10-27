func reset() -> void:
	render_backgrounds = true
	current_background.queue_free()
	current_background = null
	intended_background_name = ""
