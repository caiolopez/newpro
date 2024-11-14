extends Sprite2D

var current_tween: Tween

func _ready():
	modulate.a = 0.0
	scale = get_viewport_rect().size / texture.get_size()
	Events.hero_died.connect(start_darken)
	Events.hero_respawned_at_checkpoint.connect(end_darken)

func _start_darken():
	_kill_current_tween()
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 0.5, 0.25)

func _end_darken():
	_kill_current_tween()
	current_tween = create_tween()
	current_tween.tween_property(self, "modulate:a", 0.0, 0.25)

func _kill_current_tween():
	if current_tween and current_tween.is_valid():
		current_tween.kill()
