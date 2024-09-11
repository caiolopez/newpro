extends CanvasItem

var current_tween: Tween = null

func _ready() -> void:
	Events.curtain_fade_in.connect(_on_fade_in)
	Events.curtain_fade_out.connect(_on_fade_out)

func _on_fade_in(duration: float = 1.0) -> Tween:
	cancel_fade()
	modulate.a = 0
	show()
	current_tween = create_tween()
	if current_tween:
		current_tween.tween_property(self, "modulate:a", 1.0, duration)
		current_tween.tween_callback(Events.curtain_fade_in_ended.emit)
	else:
		push_error("Failed to create tween for fade in")
	return current_tween

func _on_fade_out(duration: float = 1.0) -> Tween:
	cancel_fade()
	current_tween = create_tween()
	if current_tween:
		current_tween.tween_property(self, "modulate:a", 0.0, duration)
		current_tween.tween_callback(Events.curtain_fade_out_ended.emit)
		current_tween.tween_callback(hide)
	else:
		push_error("Failed to create tween for fade out")
	return current_tween

func cancel_fade() -> void:
	if current_tween:
		current_tween.kill()
		current_tween = null

func is_fading() -> bool:
	return current_tween != null and current_tween.is_running()
