extends ColorRect

@onready var tween: Tween
signal close_completed
signal open_completed

func close(fade_duration: float = 1.0) -> Signal:
	if tween: tween.kill()
	tween = create_tween()
	modulate.a = 0.0
	tween.tween_property(self, "modulate:a", 1.0, fade_duration)
	tween.tween_callback(func(): close_completed.emit())
	return close_completed

func open(fade_duration: float = 1.0) -> Signal:
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	tween.tween_callback(func(): open_completed.emit())
	return open_completed
