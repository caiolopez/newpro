extends AnimatedSprite2D

enum Effects {FREE, HIDE}
@export var effect: Effects = Effects.FREE
@export var hide_if_hero_dir_changed: bool = false

func _ready():
	Events.hero_changed_dir.connect(func(_dir): visible = false)
	animation_finished.connect(func():
		match effect:
			Effects.FREE:
				queue_free()
			Effects.HIDE:
				visible = false
		)
