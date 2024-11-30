extends ColorRect

var current_tween: Tween = null

func _ready() -> void:
	hide()

func flash(duration: float = 1.0, flash_color: Color = Color.WHITE):
	if UI.options_menu.options_data["no_flash"]: return
	if current_tween:
		current_tween.kill()
		current_tween = null

	color = flash_color
	show()
	modulate.a = 1.0

	current_tween = create_tween()
	if current_tween:
		current_tween.tween_property(self, "modulate:a", 0.0, duration)
		current_tween.tween_callback(hide)
	else:
		modulate.a = 0.0
