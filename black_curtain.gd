extends CanvasItem

var current_tween: Tween = null
signal fade_in_ended
signal fade_out_ended

func fade_in(duration: float = 1.0) -> Tween:
	if current_tween:
		current_tween.kill()
	modulate.a = 0
	show()
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 1.0, duration)
	current_tween.tween_callback(fade_in_ended.emit)
	return current_tween

func fade_out(duration: float = 1.0) -> Tween:
	if current_tween:
		current_tween.kill()
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 0.0, duration)
	current_tween.tween_callback(hide)
	current_tween.tween_callback(fade_out_ended.emit)
	return current_tween

func is_fading() -> bool:
	return current_tween != null and current_tween.is_running()
